color=`tput setaf 48`
reset=`tput setaf 7`

echo
echo "${color}:Publishing ...${reset}"

SOURCE=/Users/carlson/dev/elm/projects/exp/src
DIST=/Users/carlson/dev/elm/projects/exp/public
TARGET=/Users/carlson/dev/github_pages/app/doubling

elm make --optimize ${SOURCE}/Main.elm --output=${DIST}/Main.js

echo "${color}:Uglifying ...${reset}"

uglifyjs ${DIST}/Main.js -mc 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9"' -o ${DIST}/Main.min.js

echo "${color}:Copying ...${reset}"

cp ${DIST}/index-min.html ${TARGET}/index.html
cp ${DIST}/Main.min.js ${TARGET}/
cp ${DIST}/assets/style.css ${TARGET}/assets/
cp ${DIST}/assets/custom-element-config.js ${TARGET}/assets/
cp ${DIST}/assets/math-text.js ${TARGET}/assets/
cp ${DIST}/assets/math-text-delayed.js ${TARGET}/assets/

echo "${color}cd /Users/carlson/dev/github_pages  ${reset}"








elm make --optimize src/Main.elm

echo "cd /Users/carlson/dev/github_pages/app/doubling"