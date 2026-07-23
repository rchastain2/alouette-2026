
diff fpc blaise-qbe > diff-fpc-blaise-qbe.log
diff fpc blaise-native > diff-fpc-blaise-native.log

exit 0

make distclean
make
mkdir -p blaise-qbe
mv -f *.inc blaise-qbe

make distclean
make NATIVE=1
mkdir -p blaise-native
mv -f *.inc blaise-native

make distclean
make distclean -f MakefileFPC
make -f MakefileFPC
mkdir -p fpc
mv -f *.inc fpc

make distclean
make distclean -f MakefileFPC

rm -f blaise-qbe/squarenames.inc
rm -f blaise-native/squarenames.inc
rm -f fpc/squarenames.inc
