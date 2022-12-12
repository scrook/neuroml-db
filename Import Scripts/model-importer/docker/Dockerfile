FROM jbirgio/neuron:7.7

#Expose port 5920 to view display using VNC Viewer -- VNC will only work when the container is run on a local machine
# Will need to run `unset DISPLAY` before importing NEURON
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y git x11vnc xvfb openbox menu
EXPOSE 5920
ENV DISPLAY=:20

# Run simple window manager on startup
RUN echo 'openbox-session 2> /dev/null || true &' >> /root/.bashrc

RUN conda install -y pandas=1.0.3 llvmlite pytables h5py
RUN python -m pip install pip==9.0.3
RUN pip install git+https://github.com/scidash/sciunit@4b1915afdc4eedd030982b81486a0344e6ed3985#egg=sciunit
RUN conda install -y llvmlite==0.39.1 pillow
RUN pip install git+https://github.com/justasb/neuronunit@3e59d272f3e43a19b09db8a499117fd3bc386596#egg=neuronunit
EXPOSE 8888

# Create a vnc server to share the screen and jupyter lab to view the notebook
#CMD ["sh", "-c", "\
#     x11vnc -nopw -create -rfbport 5920 -forever & disown;\
#     jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser;\
#"]
CMD ["sh", "-c", "\
     jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser;\
"]
