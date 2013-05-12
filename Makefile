
default:
	# Set default make action here
	# xcodebuild -target Tests -configuration MyMainTarget -sdk iphonesimulator build	

clean:
	-rm -rf build/*

test:
	GHUNIT_CLI=1 xcodebuild ARCHS=i386 ONLY_ACTIVE_ARCH=NO -workspace RBLChecker.xcworkspace -scheme RBLCheckerTests -configuration Debug -sdk iphonesimulator build
