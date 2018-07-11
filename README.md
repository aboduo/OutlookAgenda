# OutlookAgenda  

Simulate outlook agenda


## Prerequisite
- iOS 11, iPhoneX, do not test in other devices
- swift 4.0, XCode 9.4
- Need to update Provisioning Profile for running in real iPhone.


## Architecture
```
 ContainerViewController
 |
 |-CalendarViewController
 |      |
 |      |-CalendarHeaderView
 |      |
 |      |-collectionView
 |      |
 |      |-overlayView
 |
 |-AgendaViewController
 		 |
 		 |- tableView
 ```
 
## Explain
There are two branches in this repo you may be interested. 
The `master` branch did the most feature of the challenge. Screen recording:  

![](ScreenRecord/master.gif)  


The `innovation` branch give out a small innovation about the calendar. This branch may have some known bugs, will fix them when free. Screen recording:  

![](ScreenRecord/innovation.gif)  
 
 ## Notice
 - Add a script to make sure files in subfolders sorted in alphabetical order.
 - Support swfitlint.
 - Unit tests do not cover all cases.
 - Add weather support, just using local data, not from the network.
 - Some earlier git commits need to squash.
 - Do not add UI tests as not familiar.
 - Have not test when system calendar changed.
 - Have not take care of today changed, as just pass 00:00 AM.
 
