# Janus Recordings Post Processor

This is a utility from [Janus](https://janus.conf.meetecho.com/) team to convert mjr files created with Janus to standard formats.

I am not associated in any way with Janus or Meetecho, I'm just providing this tool.

This version of the utility ships as Docker container so it needs docker to run.

### `janus-pp-rec` file

The provided `janus-pp-rec` executable file has been compiled under alpine linux 3.6 so this docker image is based on that OS.
 
## Usage

1. `$ bash build_docker.sh`
2. `$ chmod +x run.sh && cp run.sh /usr/bin/mjr2webm-tool`
3. Convert all .mjr files in folder: `$ mjr2webm-tool`
4. Specify files to convert: `$ mjr2webm-tool mjr2webm video_12345.mjr video_54321.mjr`
