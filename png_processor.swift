#!/usr/bin/swift

// swiftc -o png_processor png_processor.swift -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers
// ./png_processor /path/to/your/png/images
import Foundation
import CoreGraphics
import UniformTypeIdentifiers
import ImageIO

// 确保命令行参数正确
guard CommandLine.argc > 1 else {
    print("使用方法: swift png_processor.swift <PNG图片文件夹路径>")
    exit(1)
}

// 获取输入路径
let inputPath = CommandLine.arguments[1]
let fileManager = FileManager.default

// 检查输入路径是否存在
guard fileManager.fileExists(atPath: inputPath) else {
    print("错误: 路径不存在 - \(inputPath)")
    exit(1)
}

// 创建输出文件夹
let outputDir1242 = URL(fileURLWithPath: inputPath).appendingPathComponent("1242_2688").path
let outputDir1320 = URL(fileURLWithPath: inputPath).appendingPathComponent("1320_2868").path

do {
    try createDirectoryIfNeeded(at: outputDir1242)
    try createDirectoryIfNeeded(at: outputDir1320)
} catch {
    print("错误: 创建输出文件夹失败 - \(error)")
    exit(1)
}

// 定义目标尺寸
let targetSizes: [(width: Int, height: Int, outputDir: String)] = [
    (1242, 2688, outputDir1242),
    (1320, 2868, outputDir1320)
]

// 获取所有PNG文件
let imageFiles = try getPNGFiles(in: inputPath)

print("找到 \(imageFiles.count) 张PNG图片，开始处理...")

// 处理每张图片
for (index, imageFile) in imageFiles.enumerated() {
    print("[\(index+1)/\(imageFiles.count)] 处理: \(imageFile.lastPathComponent)")
    
    for size in targetSizes {
        do {
            try processPNGImage(
                at: imageFile,
                to: size.width,
                height: size.height,
                outputPath: URL(fileURLWithPath: size.outputDir).appendingPathComponent(imageFile.lastPathComponent)
            )
        } catch {
            print("  错误: 处理失败 - \(error)")
        }
    }
}

print("处理完成!")
print("调整为1242x2688的图片保存在: \(outputDir1242)")
print("调整为1320x2868的图片保存在: \(outputDir1320)")

// MARK: - 辅助函数

/// 创建目录（如果不存在）
func createDirectoryIfNeeded(at path: String) throws {
    if !fileManager.fileExists(atPath: path) {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
}

/// 获取目录中所有PNG文件
func getPNGFiles(in directory: String) throws -> [URL] {
    let contents = try fileManager.contentsOfDirectory(atPath: directory)
    return contents
        .map { URL(fileURLWithPath: directory).appendingPathComponent($0) }
        .filter { $0.pathExtension.lowercased() == "png" }
}

/// 处理PNG图片：调整大小并去除alpha通道，保持PNG格式
func processPNGImage(at inputURL: URL, to width: Int, height: Int, outputPath: URL) throws {
    guard let imageSource = CGImageSourceCreateWithURL(inputURL as CFURL, nil) else {
        throw NSError(domain: "ImageProcessingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "无法读取PNG图片"])
    }
    
    guard let originalImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
        throw NSError(domain: "ImageProcessingError", code: 2, userInfo: [NSLocalizedDescriptionKey: "无法创建图片对象"])
    }
    
    // 创建RGB颜色空间
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    // 创建无alpha通道的上下文（使用RGB模式）
    guard let context = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: width * 4, // RGBA每像素4字节
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue // 无alpha通道
    ) else {
        throw NSError(domain: "ImageProcessingError", code: 3, userInfo: [NSLocalizedDescriptionKey: "无法创建绘图上下文"])
    }
    
    // 设置背景为白色（处理透明区域）
    context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    
    // 绘制调整大小后的图片
    context.draw(originalImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    
    // 创建调整后的图片
    guard let resizedImage = context.makeImage() else {
        throw NSError(domain: "ImageProcessingError", code: 4, userInfo: [NSLocalizedDescriptionKey: "无法创建调整后的图片"])
    }
    
    // 创建PNG输出
    guard let destination = CGImageDestinationCreateWithURL(
        outputPath as CFURL,
        UTType.png.identifier as CFString,
        1, [kCGImageDestinationBackgroundColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1)] as CFDictionary
    ) else {
        throw NSError(domain: "ImageProcessingError", code: 5, userInfo: [NSLocalizedDescriptionKey: "无法创建PNG输出文件"])
    }
    
    // 添加图片并保存（不使用压缩参数，使用默认设置）
    CGImageDestinationAddImage(destination, resizedImage, nil)
    
    if !CGImageDestinationFinalize(destination) {
        throw NSError(domain: "ImageProcessingError", code: 6, userInfo: [NSLocalizedDescriptionKey: "无法保存PNG图片"])
    }
    
    print("  ✓ 调整为 \(width)x\(height)，已移除alpha通道 → \(outputPath.lastPathComponent)")
}
