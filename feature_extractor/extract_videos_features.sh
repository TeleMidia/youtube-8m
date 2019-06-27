#!/bin/bash
# Script to convert, extract features from mp4 and webm videos

 #"/mnt/HDSDE/porn_videos/"
 #"/mnt/HDSDE/gore_videos/"
videos_dir_path='/mnt/HDSDE/gore_videos/' #'/mnt/HDSDE/yt_videos/'

audio_dir_path='/mnt/HDSDE/audio/'
extracted_audio_path='/mnt/HDSDE/audio_features/'
extracted_image_path='/mnt/HDSDE/image_features/'

audio_extractor_path='/home/pedropva/yt8m/code/youtube-8m/feature_extractor/audio_extractor/'
image_extractor_path='/home/pedropva/yt8m/code/youtube-8m/feature_extractor/'

features_concatenator_path='/home/pedropva/VideoMR/baseline/'

cd $videos_dir_path
#echo "$videos_dir_path"
#echo vrau
for file in "${videos_dir_path}"*;	do # also has to be done for .mp4  
	
	filename=$(basename -- "$file")
	extension=".${filename##*.}"
	filename="${filename%.*}"
	echo $filename $extension

	if [ "$extension" = ".mp4" ] || [ "$extension" = ".webm" ]; then
		if [ ! -f "${extracted_audio_path}$(basename "$file" $extension).csv" ]; then
		    	echo "Features file not found, extracting!"
		    	# WAV FILE CONVERSION
				cd $videos_dir_path
				#echo "$file" "${audio_dir_path}$(basename "$file" $extension).wav"
				~/ffmpeg/ffmpeg -n -loglevel panic -i "$file" "${audio_dir_path}$(basename "$file" $extension).wav"

				# AUDIO FEATURES EXTRACTION
				cd $audio_extractor_path
				#echo "'${audio_dir_path}$(basename "$file" $extension).wav'" 
				pipenv run python3 vggish_inference_demo.py --wav_file "${audio_dir_path}$(basename "$file" $extension).wav" \
			                                --csv_file "${extracted_audio_path}$(basename "$file" $extension).csv" \
			                                --checkpoint "${audio_extractor_path}vggish_model.ckpt" \
			                              	--pca_params "${audio_extractor_path}vggish_pca_params.npz"
		fi
	fi
done


# IMAGE FEATURES EXTRACTION
# WHATS MOST ANNOYING ABOUT THIS IS THAT WE NEED TO GIVE A CSV FILE WITHFULL PATH AND TAG TO THE EXTRACTOR
# SO WE HAVE TO MAKE A CSV FILE BY HAND
cd $image_extractor_path
pipenv run python3 extract_tfrecords_main.py \
--input_videos_csv /mnt/HDSDE/dataset.csv \
--output_tfrecords_file /mnt/HDSDE/image_features/

#FEATURES CONCATENATION
cd $features_concatenator_path
pipenv run python3 yt8m_decoder.py


