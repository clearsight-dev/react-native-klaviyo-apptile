import { NativeModules, Platform } from 'react-native'

const { KlaviyoModule } = NativeModules

class KlaviyoRN {
  static initializeKlaviyoSDK = (apiKey: string) => {
    KlaviyoModule.initializeKlaviyoSDK(apiKey)
  }

  static getExternalId = (
    callback: (externalId: string | null) => void
  ): void => {
    KlaviyoModule.getExternalId((error: any, externalId: string | null) => {
      if (error) {
        console.error('Error getting external ID:', error)
        callback(null)
      } else {
        callback(externalId)
      }
    })
  }

  static setExternalId = (externalId: string) => {
    KlaviyoModule.setExternalId(externalId)
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
