Triangulator (in Swift)
=====================

This app demonstrates how to triangulate distance between iBeacons using CoreLocation. I wrote it for a class I teach as part of Twitter's internal training program.

Triangulation is not precise because you only have 4 distances you get when ranging an iBeacon (immmediate, near, far and unknown).

## Instructions

Click on the bottom-left triangle icon (it should turn gray) to configure the iBeacons you have to match their real-life location, and click again on the triangle when you are done.

Next, click on the bottom-right scan icon to start scanning for iBeacons. Once iBeacons are in range, the location marker icon should appear. It's default position is offscreen (at -100, -100).

## Testing

This works on an iPhone 4S running iOS 7.1, with Estimote iBeacons.

## CoreLocation vs CoreBluetooth

I am using CoreLocation, which is the only accepted way of interating with iBeacons. CoreBluetooth doesn't give you the background capabilities needed in a distance-aware app. 

CoreLocation gives you iBeacon class (proximity UUID), major and minor (think of them as ways to give an iBeacon a unique ID). CoreBluetooth gives you only a deviceUUID. In fact, the information available to CoreLocation and CoreBluetooth is  mutually exclusive- they handle the iBeacon advertisements differently.

## Notes

* The app is hardcoded to use 3 iBeacons. The triangulation code could handle more of them, but the iBeacon setup would need to be modified to support this.
* The triangulation code doesn't handle the 0 < n < 3 signal case. When there are only one or two iBeacons present, we should do something different with the UI. The same goes for 0 iBeacons.
* To make CoreLocation work in iOS 8, you need to add stuff to the plist! See: http://stackoverflow.com/questions/24062509/ios-8-location-services-not-working

## Shamelessly Stolen Artwork

* Estimote iBeacons: From http://www.uidesignbyadam.com/blog/
* Wallpaper: Interfacelift (Sandy Cay is the current background)

## Credits

* People who's artwork I stole (see above)
* Coworkers at Twitter who made helpful suggestions to my coding style
