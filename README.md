`docker build --progress=plain . -t tomasz-lisowski/pysim:2.0.0 2>&1 | tee docker.log;`
`docker run --device=/dev/bus/usb/<usb_reader_path> --tty --interactive --rm tomasz-lisowski/pysim:2.0.0;`
