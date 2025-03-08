import class CoreGraphics.CGColorSpace
import func CoreGraphics.CGColorSpaceCreateDeviceGray
import struct CoreGraphics.CGSize
import struct CoreImage.CIFormat
import class CoreImage.CIImage
import struct Foundation.Data
import struct Foundation.URL
import typealias FpUtil.IO
import typealias ImageToPng.WriteImage

public struct Point {
  public let x: UInt16
  public let y: UInt16

  public static func fromIndex(index: Int, width: Int) -> Self {
    let x: Int = index % width
    let y: Int = index / width
    return Self(x: UInt16(x), y: UInt16(y))
  }
}

public typealias Mono = UInt8

public typealias ColorRGBA = UInt32

public typealias PointToMono = (Point) -> Mono
public typealias PointToColorRGBA = (Point) -> ColorRGBA

public func PointToMonoStatic(mono: Mono) -> PointToMono {
  return {
    let _: Point = $0
    return mono
  }
}

public func PointToMonoHline(
  y: UInt16,
  lineColor: Mono,
  backgroundColor: Mono
) -> PointToMono {
  return {
    let pnt: Point = $0
    return (y == pnt.y) ? lineColor : backgroundColor
  }
}

public func PointToMonoVline(
  x: UInt16,
  lineColor: Mono,
  backgroundColor: Mono
) -> PointToMono {
  return {
    let pnt: Point = $0
    return (x == pnt.x) ? lineColor : backgroundColor
  }
}

public func PointToMonoVlineEven(
  lineColor: Mono,
  backgroundColor: Mono
) -> PointToMono {
  return {
    let pnt: Point = $0
    let x: UInt16 = pnt.x
    let isEven: Bool = 0 == (x & 1)
    return isEven ? lineColor : backgroundColor
  }
}

public struct MonoToPng {
  public let size: CGSize
  public let converter: PointToMono

  public func withSize(size: CGSize) -> Self {
    Self(size: size, converter: self.converter)
  }

  public func withConverter(converter: @escaping PointToMono) -> Self {
    Self(size: self.size, converter: converter)
  }

  public static func fromConverter(
    size: CGSize, converter: @escaping PointToMono
  ) -> Self {
    Self(size: size, converter: converter)
  }

  public static func fromMono(
    size: CGSize,
    mono: Mono
  ) -> Self {
    Self.fromConverter(
      size: size,
      converter: PointToMonoStatic(mono: mono)
    )
  }

  public func width() -> Int { Int(self.size.width) }
  public func height() -> Int { Int(self.size.height) }
  public func byteSize() -> Int { self.width() * self.height() }

  public func bytesPerPixel() -> Int { 1 }
  public func bytesPerRow() -> Int { self.width() * self.bytesPerPixel() }

  public func format() -> CIFormat { .L8 }
  public func colorSpace() -> CGColorSpace { CGColorSpaceCreateDeviceGray() }

  public func index2mono(index: Int, width: Int) -> Mono {
    let pnt: Point = .fromIndex(index: index, width: width)
    return self.converter(pnt)
  }

  public func data2img(data: inout Data) -> CIImage {
    let width: Int = self.width()
    let sz: Int = data.count

    for i in 0..<sz {
      let pix: Mono = self.index2mono(index: i, width: width)
      data[i] = pix
    }

    return CIImage(
      bitmapData: data,
      bytesPerRow: self.bytesPerRow(),
      size: self.size,
      format: self.format(),
      colorSpace: self.colorSpace()
    )
  }

  public func data2png(
    data: inout Data,
    pngUrl: URL,
    pngWriter: WriteImage
  ) -> IO<Void> {
    let writeImage: (CIImage) -> IO<Void> = pngWriter(pngUrl)
    let img: CIImage = self.data2img(data: &data)
    return writeImage(img)
  }
}
