#!/bin/bash
# Script to convert, extract features from mp4 and webm videos

 #"/mnt/HDSDE/yt_videos/" "/mnt/HDSDE/gore_videos/")
videos_dir_path='/mnt/HDSDE/gore_videos/'
audio_dir_path='/mnt/HDSDE/audio/'
extracted_dir_path='/mnt/HDSDE/audio_features/'
base_vgggish='/home/pedropva/yt8m/code/youtube-8m/feature_extractor/audio_extractor/'

#echo "$videos_dir_path*.webm"
cd $videos_dir_path
for file in "${videos_dir_path}"*.webm;	do
	#echo "${videos_dir_path}$file" "${audio_dir_path}$(basename "$file" .webm).wav"
	~/ffmpeg/ffmpeg -i "$file" "${audio_dir_path}$(basename "$file" .webm).wav"
	cd $base_vgggish
	pipenv run python3 vggish_inference_demo.py --wav_file "$filfdfe.wav"
                                --tfrecord_file "${extracted_ir_path}$(basename "$file" .webm).tfrecords"
                                --checkpoint "${base_vgggish}vggish_model.ckpt"
                              	--pca_params "${base_vgggish}vggish_pca_params.npz"
done




