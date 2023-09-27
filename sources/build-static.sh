# build Playpen fonts

set -e

ttfFontsPath="../fonts/static/ttf"
webFontsPath="../fonts/static/web"
scripts="./scripts"

rm -rf $ttfFontsPath # $webFontsPath
mkdir -p $ttfFontsPath # $webFontsPath

# pack source as .glyphspackage is not supported yet by fontmake
echo
echo "glyphspkg: Converting Playpen_MM.glyphspackage to Playpen_MM.glyphs"
glyphspkg Playpen_MM.glyphspackage

echo "
=========================
 Generating STATIC fonts
=========================
 $(date "+ 📅 DATE: %Y-%m-%d%n  🕒 TIME: %H:%M:%S")"
echo

# Build TTF fonts
fontmake -g ./Playpen_MM.glyphs -i -o ttf --output-dir $ttfFontsPath \
          --filter DecomposeTransformedComponentsFilter \
          --flatten-components

echo "
======================
 Post processing TTFs 
======================
"
ttfs=$(ls $ttfFontsPath/*.ttf)
for ttf in $ttfs
do
  python -m ttfautohint -n $ttf "$ttf.hint"
  mv "$ttf.hint" $ttf
  gftools fix-hinting $ttf
  echo $ttf
done

