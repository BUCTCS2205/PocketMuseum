import { fileIo } from '@kit.CoreFileKit';
import resourceManager from '@ohos.resourceManager';
import image from "@ohos.multimedia.image";
import { util } from "@kit.ArkTS";

export async function loadResourcePicture(name: string): Promise<image.PixelMap> {
  const rm = getContext().resourceManager as resourceManager.ResourceManager;
  const buffer = await rm.getMediaByName(name);
  const src = image.createImageSource(buffer);
  let opts: image.DecodingOptions = { editable: true }
  return await src.createPixelMap(opts);
}

export async function loadDeviceImage(uri: string, size?: Size) {
  const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
  const photoSize = fileIo.statSync(file.fd).size;
  let buffer = new ArrayBuffer(photoSize);
  fileIo.readSync(file.fd, buffer);
  fileIo.closeSync(file);

  const imageSource = image.createImageSource(buffer);
  const pixel = await imageSource.createPixelMap({
    editable: false,
    desiredSize: size
  });
  return pixel;
}

export function base64ToBuffer(str: string): ArrayBuffer {
  const helper = new util.Base64Helper();
  const temp: Uint8Array = helper.decodeSync(str);
  const res: ArrayBuffer = temp.buffer as ArrayBuffer;
  return res;
}

export function pixelMapToBuffer(pm: image.PixelMap): ArrayBuffer {
  const buffer = new ArrayBuffer(pm.getPixelBytesNumber());
  pm.readPixelsToBufferSync(buffer);
  return buffer;
}

export function bufferToBase64(buffer: ArrayBuffer): string {
  const temp = new Uint8Array(buffer);
  const helper = new util.Base64Helper();
  const res = helper.encodeToStringSync(temp);
  return res;
}

export async function pixelMapToBase64(pixelMap: image.PixelMap): Promise<string> {
  const imagePackageApi: image.ImagePacker = image.createImagePacker();
  let packOpts: image.PackingOption = {
    format: 'image/jpeg',
    quality: 100,
  };
  const readBuffer = await imagePackageApi.packToData(pixelMap, packOpts);
  const uint8Arr = new Uint8Array(readBuffer);
  const helper = new util.Base64Helper();
  const base64 = helper.encodeToStringSync(uint8Arr);
  return base64;
}

export function base64ToPixelMap(base64: string): Promise<PixelMap> {
  const base64Helper = new util.Base64Helper();
  const arrayBuffer = base64Helper.decodeSync(base64).buffer as ArrayBuffer;
  const imageSource = image.createImageSource(arrayBuffer);
  const opts: image.DecodingOptions = { editable: false };
  return imageSource.createPixelMap(opts);
}
