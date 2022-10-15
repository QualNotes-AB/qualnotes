# Qualnote

## Authentication debug SHA1 key set up

For the firebase authentication to work properly on your machine, you will need to generate SHA1 and SHA256 key
and add it to the android project settings.
To generate a debug SHA1 key, depending on you system, 
* For Windows you will run this command in your terminal 
```
keytool -list -v -keystore "\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

* For MacOS run
```
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

in the terminal you should see a section Certificate fingerprints under which is SHA1 and SHA256 labeled.

If you get an error saying that keystore can not be found or something similar, you need to install java sdk from their website

When you've succesfuly generated SHA1 and SHA256 go to firebase project click on the settings icon located next to project overview and select project settings.

After that make sure that "General" tab us selected and scroll down until you see "Your apps" section, make sure that android app is selected.

At the bottom you will click on a button that says "Add fingerprint" and paste your SHA1 and SHY256 keys.

Hit save for each one and you're all done.

Once this is done, go to your project and clean it:
```
flutter clean
```

Once this is doen you can run it.

Also here is a link of the official firebase guide on SHA1 set up 
https://developers.google.com/android/guides/client-auth?authuser=0&hl=en
and a stackoverflow answer
https://stackoverflow.com/questions/51845559/generate-sha-1-for-flutter-react-native-android-native-app
##
