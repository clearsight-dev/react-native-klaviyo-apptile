import { NativeModules, Platform } from 'react-native'

const { KlaviyoModule } = NativeModules

class KlaviyoRN {
  static initializeKlaviyoSDK = (apiKey: string) => {
    KlaviyoModule.initializeKlaviyoSDK(apiKey)
  }

  static identify = (userDetails: Record<string, string>) => {
    KlaviyoModule.identify(userDetails)
  }

  static resetIdentity = () => {
    KlaviyoModule.resetIdentity()
  }

  static sendEvent = (
    eventMetric: string,
    eventData: {
      value?: number
      properties?: Record<string, string>
    }
  ) => {
    KlaviyoModule.sendEvent(eventMetric, eventData)
  }

  static setPushToken = (token: string) => {
    if (Platform.OS === 'ios') {
      KlaviyoModule.setPushToken(token)
    }
  }
}

export default KlaviyoRN
