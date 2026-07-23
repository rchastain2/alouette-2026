
ReplaceWords()
{
  for WORD in \
    Int64 \
    WriteLn
  do
    sed -i -E "s/\b$WORD\b/$WORD/gI" $1
  done
}

find . -name "*.pas" | while read file; do ReplaceWords "$file"; done
# https://stackoverflow.com/a/8489394/18595765

exit 0

find ./ -type f -exec sed -i 's/old_string/new_string/gI' {} \;

for x in *.pas
do
  echo "$x"
done

for f in $(find . -name "*.inc" | sort)
do
  echo $f
done
