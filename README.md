From [MobiDevDay 2013](http://mobidevdaydetroit.com/)

## Presentation

The slides are up on [Speaker Deck](https://speakerdeck.com/andrewsardone/reactivecocoa-at-mobidevday-2013). A large portion of the talk involved narrating a walkthrough of the code, so [I posted a recording](https://vimeo.com/65637501).

## Getting started with the code

The example project is a direct rip-off of [@joshaber's](https://github.com/joshaber) [RACSignupDemo](https://github.com/joshaber/RACSignupDemo), but the commits transform the app from standard Cocoa Touch to some awesome RAC-ified code :boom:. Also, the app uses a [tiny web service](https://github.com/andrewsardone/RACMobiDevDay/blob/master/server.rb) so you can see how we wrap a simple [AFNetworking-based API client](https://github.com/andrewsardone/RACMobiDevDay/blob/master/RACMobiDevDay/APIClient.m) to return `RACSignal` objects instead of using success-failure callback blocks.

**UPDATE** Since the recording of the presentation the underlying libraries have changed significantly. This renders the code used in the presentation not be directly applicable to the current versions. Therefore, the code in the repo has been updated. The version for the original code used in the recording is accessible at https://github.com/andrewsardone/RACMobiDevDay/tree/f09ae4df509bf0efcfbce9214916503ea16d39f4

First bootstrap your environment:

```
script/bootstrap
```

Then to start the web service:

```
script/server
```

Now you can open `RACMobiDevDay.xcworkspace` in Xcode and start playing around!

## Additional resources

- https://github.com/ReactiveCocoa
- https://pinboard.in/u:andrewsardone/t:ReactiveCocoa
- https://github.com/andrewsardone/RACMobiDevDay
- http://nsbrief.com/81-justin-spahr-summers/
- http://j.mp/joshaberio
- http://j.mp/reactiveextensions
- https://github.com/mneorr/ObjectiveSugar
