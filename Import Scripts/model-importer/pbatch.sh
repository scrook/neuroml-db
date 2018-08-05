cd batch

rm x*.sh

dos2unix simrun.sh

split -d --additional-suffix=.sh -l $(expr `wc -l simrun.sh | cut -d ' ' -f1` / $1) simrun.sh

chmod -R +x .

cd ..
find . -type f -name "x*.sh" -exec gnome-terminal -e {} \& disown \;


