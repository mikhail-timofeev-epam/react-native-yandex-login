declare module "react-native-yandex-login" {
  export default class Manager {
    static timeToStartCheckout(id: string):Promise<Array[]>;
    static activate(clientId: string): void;
  }
}
