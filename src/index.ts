import { NativeModules, Platform } from 'react-native'

const { KlaviyoModule } = NativeModules

export const NativeModulesExport = { ...NativeModules }
export default NativeModules

export const initializeKlaviyoSDK = (apiKey: string) => {
  console.log('KlaviyoModule', KlaviyoModule)
  KlaviyoModule.initializeKlaviyoSDK(apiKey)
}

export const setExternalId = (externalId: string) => {
  KlaviyoModule.setExternalId(externalId)
}

// export const getExternalId = (callback: Function | undefined): String | null => {
//   return KlaviyoModule.getExternalId(callback);
// }

// export const getExternalId = async (): Promise<string | null> => {
//   try {
//     const externalId = await KlaviyoModule.getExternalId();
//     return externalId;
//   } catch (error) {
//     console.error("Error getting external ID:", error);
//     return null;
//   }
// };

export const getExternalId = (
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

export const setPushToken = (token: string) => {
  if (Platform.OS === 'ios') {
    KlaviyoModule.setPushToken(token)
  }
}

// export const getExternalId = (callback: (error: any, externalId: string | null) => void): void => {
//   KlaviyoModule.getExternalId((error: any, externalId: string | null) => {
//     if (error) {
//       console.error("Error getting external ID:", error);
//       callback(error, null);
//     } else {
//       callback(null, externalId);
//     }
//   });
// };
