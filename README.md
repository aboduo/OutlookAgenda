#OutlookAgenda   
My answer solution to [iOS Engineer Challenge](https://github.com/outlook/jobs/blob/master/instructions/ios/ios-engineer.md)

## Prerequisite
- iOS 11, iPhoneX, do not test in other devices
- swift 4.0, XCode 9.4


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
 
 
 ## Notice
 - Unit test does not cover all cases.
 - Add weather support, just using local data not from network.
 - Some ealier git commits need to squash.
 - Do not add UI tests as not familiar.
 
