//
//  CreatePDFView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 19/04/2024.
//

import SwiftUI

struct CreatePDFView: View {
    var body: some View {
         Button("Create PDF") {
             createPDF()
         }
     }

     func createPDF() {
         let pageSize = CGSize(width: 612, height: 792)  // Standard A4 size
         let pageRect = CGRect(origin: .zero, size: pageSize)
         let margin: CGFloat = 20
         let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

         let data = renderer.pdfData { ctx in
             ctx.beginPage()  // First page
             drawHeader(ctx: ctx, pageRect: pageRect, margin: margin)
             drawTripTable(ctx: ctx, pageRect: pageRect, margin: margin)

             ctx.beginPage()  // Second page
             drawAbbreviations(ctx: ctx, pageRect: pageRect, margin: margin)

             ctx.beginPage()  // Third page
             drawSummaryAndDeclarations(ctx: ctx, pageRect: pageRect, margin: margin)
         }

         savePDF(data: data)
     }

     func drawHeader(ctx: UIGraphicsPDFRendererContext, pageRect: CGRect, margin: CGFloat) {
         let titleAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.boldSystemFont(ofSize: 18)
         ]
         let title = "Driver's Log SA"
         let permitNumber = "Permit# FS5137"
         
         title.draw(at: CGPoint(x: margin, y: margin), withAttributes: titleAttributes)
         permitNumber.draw(at: CGPoint(x: pageRect.width - margin - permitNumber.size(withAttributes: titleAttributes).width, y: margin), withAttributes: titleAttributes)
         
         ctx.cgContext.move(to: CGPoint(x: margin, y: 40))
         ctx.cgContext.addLine(to: CGPoint(x: pageRect.width - margin, y: 40))
         ctx.cgContext.strokePath()
     }

     func drawTripTable(ctx: UIGraphicsPDFRendererContext, pageRect: CGRect, margin: CGFloat) {
         let startY = 60.0
         let headers = ["Date", "Start", "Finish", "Duration", "Distance", "From", "To", "Road", "Weather", "Traffic"]
         let columnWidths = [60.0, 50.0, 50.0, 50.0, 60.0, 100.0, 100.0, 50.0, 50.0, 50.0].map { CGFloat($0) }
         let tableWidth = columnWidths.reduce(0, +)
         let startX = (pageRect.width - tableWidth) / 2
         var currentY = startY
         
         // Draw header
         for (index, header) in headers.enumerated() {
             let frame = CGRect(x: startX + CGFloat(columnWidths[0..<index].reduce(0, +)), y: currentY, width: columnWidths[index], height: 20)
             drawText(header, in: frame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .gray)
         }
         
         currentY += 20
         // Example: Drawing one row of sample data, repeat as necessary
         let sampleData = ["1/1/2022", "08:00", "09:00", "1h", "15km", "Home", "Office", "City", "Clear", "Light"]
         for (index, data) in sampleData.enumerated() {
             let frame = CGRect(x: startX + CGFloat(columnWidths[0..<index].reduce(0, +)), y: currentY, width: columnWidths[index], height: 20)
             drawText(data, in: frame, withAlignment: .center, fontSize: 10, isBold: false)
         }
     }

    func drawAbbreviations(ctx: UIGraphicsPDFRendererContext, pageRect: CGRect, margin: CGFloat) {
        let startY = margin
        let columnWidths = [100.0, 50.0, 100.0, 50.0, 100.0, 50.0].map { CGFloat($0) }
        let rowHeight: CGFloat = 20.0
        let startX = (pageRect.width - columnWidths.reduce(0, +)) / 2

        let headers = ["Road Type", "Abb.", "Weather", "Abb.", "Traffic Density", "Abb."]
        let data = [
            ("Sealed", "S"), ("Wet", "W"), ("Light", "L"),
            ("Unsealed", "U"), ("Dry", "D"), ("Medium", "M"),
            ("Quiet Street", "Q"), ("", ""), ("Heavy", "H")
        ]

        // Draw headers
        for (index, header) in headers.enumerated() {
            let frame = CGRect(x: startX + CGFloat(columnWidths[0..<index].reduce(0, +)), y: startY, width: columnWidths[index], height: rowHeight)
            drawText(header, in: frame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .darkGray, textColor: .white)
        }
        
        // Draw data rows
        var currentY = startY + rowHeight
        for (index, (text, abbreviation)) in data.enumerated() {
            let colIndex = index % 3 * 2
            let textFrame = CGRect(x: startX + CGFloat(columnWidths[0..<colIndex].reduce(0, +)), y: currentY, width: columnWidths[colIndex], height: rowHeight)
            drawText(text, in: textFrame, withAlignment: .left, fontSize: 10, backgroundColor: .lightGray)

            let abbrFrame = CGRect(x: startX + CGFloat(columnWidths[0..<(colIndex + 1)].reduce(0, +)), y: currentY, width: columnWidths[colIndex + 1], height: rowHeight)
            drawText(abbreviation, in: abbrFrame, withAlignment: .center, fontSize: 10, backgroundColor: .lightGray)

            if (index + 1) % 3 == 0 {
                currentY += rowHeight
            }
        }
    }

    func drawSummaryAndDeclarations(ctx: UIGraphicsPDFRendererContext, pageRect: CGRect, margin: CGFloat) {
        let startX = margin
        let startY = margin
        let columnWidth = (pageRect.width - 2 * margin) / 3
        let rowHeight: CGFloat = 20.0
        
        // Draw Summary Table with headers
        let headers = ["Driving Time", "Total Hours", "Total Distance"]
        for (index, header) in headers.enumerated() {
            let frame = CGRect(x: startX + CGFloat(index) * columnWidth, y: startY, width: columnWidth, height: rowHeight)
            drawText(header, in: frame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .darkGray, textColor: .white)
        }
        
        // Summary Data
        let data = [("Day Time", "2.86h", "70.77km"), ("Night Time", "2.47h", "150.16km"), ("Total", "5.33h", "220.93km")]
        var currentY = startY + rowHeight

        for row in data {
            let rowArray = [row.0, row.1, row.2]  // Convert tuple to array
            for (index, text) in rowArray.enumerated() {
                let frame = CGRect(x: startX + CGFloat(index) * columnWidth, y: currentY, width: columnWidth, height: rowHeight)
                drawText(text, in: frame, withAlignment: .center, fontSize: 10, backgroundColor: .white)
            }
            currentY += rowHeight
        }


        // Draw Declarations
        currentY += rowHeight  // Spacer
        drawDeclaration(ctx: ctx, startX: startX, startY: currentY, pageRect: pageRect, title: "Declaration by Learner Driver (Compulsory)", details: "I ______________________ declare that I have completed 75 hours (4,500 minutes) of driving experience, including at least 15 hours (900 minutes) of night driving.")
    }

    func drawDeclaration(ctx: UIGraphicsPDFRendererContext, startX: CGFloat, startY: CGFloat, pageRect: CGRect, title: String, details: String) {
        let margin: CGFloat = 20
        let titleFrame = CGRect(x: startX, y: startY, width: pageRect.width - 2 * margin, height: 20)
        drawText(title, in: titleFrame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .darkGray, textColor: .white)

        let detailsFrame = CGRect(x: startX, y: startY + 20, width: pageRect.width - 2 * margin, height: 40)
        drawText(details, in: detailsFrame, withAlignment: .left, fontSize: 10)
        
        let signatureText = "Signature: ________________    Date: ________________"
        let signatureFrame = CGRect(x: startX, y: startY + 60, width: pageRect.width - 2 * margin, height: 20)
        drawText(signatureText, in: signatureFrame, withAlignment: .left, fontSize: 10)
    }

    func drawText(_ text: String, in rect: CGRect, withAlignment alignment: NSTextAlignment, fontSize: CGFloat, isBold: Bool = false, backgroundColor: UIColor = .white, textColor: UIColor = .black) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .font: isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: textColor,
            .backgroundColor: backgroundColor
        ]
        text.draw(in: rect, withAttributes: attributes)
    }
     func savePDF(data: Data) {
         guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
         let pdfPath = documentDirectory.appendingPathComponent("DayTimeLog2page.pdf")
         
         do {
             try data.write(to: pdfPath)
             print("PDF created at: \(pdfPath)")
         } catch {
             print("Could not save PDF: \(error)")
         }
     }
 }

#Preview {
    CreatePDFView()
}
