set -e

# Copy over gemfiles needed for the build
cp ../NeuroML-DB.org/Gemfile Gemfile
cp ../NeuroML-DB.org/Gemfile.lock Gemfile.lock

docker build -t neuromldb:latest .
