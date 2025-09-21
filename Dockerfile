# FROM --platform=linux/amd64 docker.io/library/python:3.10-slim AS example-algorithm-amd64


# #FROM --platform=linux/amd64 pytorch/pytorch AS example-algorithm-amd64
# # Use a 'large' base container to show-case how to load pytorch and use the GPU (when enabled)

# # Ensures that Python output to stdout/stderr is not buffered: prevents missing information when terminating
# ENV PYTHONUNBUFFERED=1

# RUN groupadd -r user && useradd -m --no-log-init -r -g user user
# USER user

# WORKDIR /opt/app

# COPY --chown=user:user requirements.txt /opt/app/
# COPY --chown=user:user resources /opt/app/resources

# # You can add any Python dependencies to requirements.txt
# RUN python -m pip install \
#     --user \
#     --no-cache-dir \
#     --no-color \
#     --requirement /opt/app/requirements.txt

# COPY --chown=user:user inference.py /opt/app/

# ENTRYPOINT ["python", "inference.py"]
FROM --platform=linux/amd64 python:3.10-slim AS example-algorithm-amd64

# Prevent Python output buffering
ENV PYTHONUNBUFFERED=1

# Install system-level dependencies required by OpenCV, ffmpeg, etc.
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
        libgl1 \
        libglib2.0-0 \
        ffmpeg \
        && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r user && useradd -m --no-log-init -r -g user user
USER user

WORKDIR /opt/app

# Copy requirements + resources
COPY --chown=user:user requirements.txt /opt/app/
COPY --chown=user:user resources /opt/app/resources

# Install Python dependencies
RUN python -m pip install \
    --user \
    --no-cache-dir \
    --no-color \
    --requirement /opt/app/requirements.txt

# Copy code
COPY --chown=user:user inference.py output_format.py frame_extract.py /opt/app/

# Copy test + output + model folders to the same paths inside the container
COPY --chown=user:user test /test
COPY --chown=user:user output /opt/app/output
COPY --chown=user:user model /opt/app/model
COPY --chown=user:user images /opt/app/images

ENTRYPOINT ["python", "inference.py"]
