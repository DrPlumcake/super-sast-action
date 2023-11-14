# FROM super-sast, copy-paste the Dockerfile is better?

FROM ghcr.io/par-tec/super-sast as super-sast

FROM docker.io/library/python:3.11.1-alpine as base_python
COPY --from=super-sast / /

# RUN apt-get update
COPY main.py /
COPY entrypoint.sh /
COPY sast_to_log.py /

RUN mkdir parse_scripts
COPY parse_scripts/* /parse_scripts
COPY request.py /

RUN chmod +x /entrypoint.sh
RUN chmod +x /sast_to_log.py
RUN chmod +x /main.py

USER 1000

# Since this is a job container, we don't need an healthcheck.
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
