import class CoreGraphics.CGColorSpace
import struct CoreGraphics.CGSize
import class CoreImage.CIContext
import struct CoreImage.CIFormat
import struct Foundation.Data
import struct Foundation.URL
import typealias FpUtil.IO
import typealias FuncToPng.Mono
import struct FuncToPng.MonoToPng
import struct FuncToPng.Point
import typealias FuncToPng.PointToMono
import func FuncToPng.PointToMonoVlineEven
import func ImageToPng.ImageWriterNew
import struct ImageToPng.PngWriteOption
import typealias ImageToPng.WriteImage

@main
struct MonoFill {
  static func main() {
    let mono: Mono = 0x7f
    let size: CGSize = CGSize(width: 16.0, height: 5.0)
    let pnt2mono: PointToMono = PointToMonoVlineEven(
      lineColor: 0x7f,
      backgroundColor: 0x00
    )
    let conv: MonoToPng = .fromMono(size: size, mono: mono)
      .withConverter(converter: pnt2mono)
    var dat: Data = Data(count: conv.byteSize())
    let pngUrl: URL = URL(fileURLWithPath: "./out.png")
    let color: CGColorSpace = conv.colorSpace()
    let fmt: CIFormat = conv.format()
    let pwo: PngWriteOption = .deviceGray(fmt: .L8)
      .withColor(color: color)
      .withFormat(fmt: fmt)
    let ictx: CIContext = CIContext()
    let wtr: WriteImage = ImageWriterNew(ictx: ictx, opt: pwo)

    let writeMonoFillPng: IO<Void> = conv.data2png(
      data: &dat,
      pngUrl: pngUrl,
      pngWriter: wtr
    )

    let res: Result<_, _> = writeMonoFillPng()

    do {
      try res.get()
    } catch {
      print("err: \( error )")
    }
  }
}
