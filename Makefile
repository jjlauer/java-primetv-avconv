demo-version:
	cd mfz-primetv-avconv-demo && mvn -e test-compile exec:java -Dexec.classpathScope="compile" -Dexec.mainClass="com.mfizz.primetv.avconv.VersionDemo"
	
demo-thumbnail:
	cd mfz-primetv-avconv-demo && mvn -e test-compile exec:java -Dexec.classpathScope="compile" -Dexec.mainClass="com.mfizz.primetv.avconv.ThumbnailDemo"