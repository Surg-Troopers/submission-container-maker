# surgvu2025-category1-submission
To rebuild the container through CLI, simply run:
```
cd submission-container-maker/
./do_save.sh
```

The model parameters have been saved inside the folder 'model/'.

In the `inference.py` file, a new frame extraction function and output formatter have been used to extract the frames from video and provide the output in a json file for the challenge submission.

> [!NOTE]
> Please uncomment the command to fetch resources in `.gitattributes` before running the `./do_save.sh` to build the container. Also please remember to add the required files to the resources/ folder.