//
//  PDFFormattedView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 19/04/2024.
//

import SwiftUI

struct PDFFormattedView: View {
    
    var body: some View {
        Button("Create PDF") {
            createPDF()
        }
    }
    
    func createPDF() {
        let pageSize = CGSize(width: 612, height: 792)
        let pageRect = CGRect(origin: .zero, size: pageSize)
        let margin = 20.0
        let contentRect = pageRect.insetBy(dx: margin, dy: margin)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            let title = "Driver's Log SA"
            title.draw(at: CGPoint(x: margin, y: margin), withAttributes: titleAttributes)
            
            let permitNumber = "Permit# FS5137"
            let permitAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            permitNumber.draw(at: CGPoint(x: pageRect.width - margin - permitNumber.size(withAttributes: permitAttributes).width, y: margin), withAttributes: permitAttributes)
            
            // Drawing a separator line
            let separatorY: CGFloat = 50
            ctx.cgContext.move(to: CGPoint(x: margin, y: separatorY))
            ctx.cgContext.addLine(to: CGPoint(x: pageRect.width - margin, y: separatorY))
            ctx.cgContext.setLineWidth(1.0)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            // Draw a table here
            drawTable(at: CGPoint(x: margin, y: separatorY + 10), in: ctx.cgContext, contentRect: contentRect)
            
            
            
            ctx.beginPage()  // Second page
            drawAbbreviations(ctx: ctx, pageRect: pageRect, margin: margin)
            
            ctx.beginPage()  // Third page
            drawSummaryAndDeclarations(ctx: ctx, pageRect: pageRect, margin: margin)
            
            // This function should be filled with additional pages and content as needed
        }
        
        savePDF(data: data)
    }
    
    func drawSummaryAndDeclarations(ctx: UIGraphicsPDFRendererContext, pageRect: CGRect, margin: CGFloat) {
        let startX = margin
        let startY = margin
        let columnWidth = (pageRect.width - 2 * margin) / 3
        let rowHeight: CGFloat = 20.0
        
        ctx.cgContext.saveGState()
        ctx.cgContext.translateBy(x: startX, y: startY)
        
        // Draw Summary Table with headers
        let headers = ["Driving Time", "Total Hours", "Total Distance"]
        for (index, header) in headers.enumerated() {
            let frame = CGRect(x: CGFloat(index) * columnWidth, y: 0, width: columnWidth, height: rowHeight)
            ctx.cgContext.setFillColor(UIColor.darkGray.cgColor)
            ctx.cgContext.fill(frame)
            drawText(header, in: frame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .clear, textColor: .white)
        }
        
        // Summary Data
        let data = [("Day Time", "2.86h", "70.77km"), ("Night Time", "2.47h", "150.16km"), ("Total", "5.33h", "220.93km")]
        var currentY = rowHeight

        for (time, hours, distance) in data {
            let rowItems = [time, hours, distance]
            for (index, text) in rowItems.enumerated() {
                let frame = CGRect(x: CGFloat(index) * columnWidth, y: currentY, width: columnWidth, height: rowHeight)
                ctx.cgContext.setFillColor(UIColor.white.cgColor)
                ctx.cgContext.fill(frame)
                drawText(text, in: frame, withAlignment: .center, fontSize: 10, backgroundColor: .clear)
            }
            currentY += rowHeight
        }

        ctx.cgContext.restoreGState()

        // Draw Declarations
        currentY += startY + rowHeight  // Adjust startY for declarations
        drawDeclaration(ctx: ctx, startX: startX, startY: currentY, pageRect: pageRect, title: "Declaration by Learner Driver (Compulsory)", details: "I ______________________ declare that I have completed 75 hours (4,500 minutes) of driving experience, including at least 15 hours (900 minutes) of night driving.")
    }

    
    func drawDeclaration(ctx: UIGraphicsPDFRendererContext, startX: CGFloat, startY: CGFloat, pageRect: CGRect, title: String, details: String) {
        let margin: CGFloat = 20
        let titleFrame = CGRect(x: startX, y: startY, width: pageRect.width - 2 * margin, height: 20)
        ctx.cgContext.setFillColor(UIColor.darkGray.cgColor)
        ctx.cgContext.fill(titleFrame)
        drawText(title, in: titleFrame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .clear, textColor: .white)

        let detailsFrame = CGRect(x: startX, y: startY + 20, width: pageRect.width - 2 * margin, height: 40)
        drawText(details, in: detailsFrame, withAlignment: .left, fontSize: 10)

        let signatureText = "Signature: ________________    Date: ________________"
        let signatureFrame = CGRect(x: startX, y: startY + 60, width: pageRect.width - 2 * margin, height: 20)
        drawText(signatureText, in: signatureFrame, withAlignment: .left, fontSize: 10)
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

        ctx.cgContext.saveGState()
        ctx.cgContext.translateBy(x: startX, y: startY)

        // Draw headers with background
        for (index, header) in headers.enumerated() {
            let headerFrame = CGRect(x: CGFloat(columnWidths[0..<index].reduce(0, +)), y: 0, width: columnWidths[index], height: rowHeight)
            ctx.cgContext.setFillColor(UIColor.darkGray.cgColor)
            ctx.cgContext.fill(headerFrame)
            drawText(header, in: headerFrame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .clear, textColor: .white)
        }
        
        // Draw data rows
        var currentY = rowHeight
        for (index, (text, abbreviation)) in data.enumerated() {
            let colIndex = index % 3 * 2
            let textFrame = CGRect(x: CGFloat(columnWidths[0..<colIndex].reduce(0, +)), y: currentY, width: columnWidths[colIndex], height: rowHeight)
            let abbrFrame = CGRect(x: CGFloat(columnWidths[0..<(colIndex + 1)].reduce(0, +)), y: currentY, width: columnWidths[colIndex + 1], height: rowHeight)

            // Set background color for rows
            ctx.cgContext.setFillColor(UIColor.lightGray.cgColor)
            ctx.cgContext.fill(textFrame)
            ctx.cgContext.fill(abbrFrame)

            // Draw text in the respective cells
            drawText(text, in: textFrame, withAlignment: .left, fontSize: 10, backgroundColor: .clear)
            drawText(abbreviation, in: abbrFrame, withAlignment: .center, fontSize: 10, backgroundColor: .clear)

            if (index + 1) % 3 == 0 {
                currentY += rowHeight
            }
        }

        ctx.cgContext.restoreGState()
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
    
    func drawTable(at point: CGPoint, in context: CGContext, contentRect: CGRect) {
        // Example of drawing a simple table
        let headers = ["Date", "Start", "Finish", "Duration", "Distance", "From", "To", "Road", "Weather", "Traffic"]
        let rowHeight: CGFloat = 20.0
        let columnWidth = (contentRect.width) / CGFloat(headers.count)
        
        context.saveGState()
        context.translateBy(x: point.x, y: point.y)
        
        // Draw header
        for (index, header) in headers.enumerated() {
            let headerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor.white
            ]
            let frame = CGRect(x: CGFloat(index) * columnWidth, y: 0, width: columnWidth, height: rowHeight)
            context.setFillColor(UIColor.gray.cgColor)
            context.fill(frame)
            let textRect = frame.insetBy(dx: 2, dy: 2)
            header.draw(in: textRect, withAttributes: headerAttributes)
        }
        
        // Draw rows (example static data here)
        let data = [
            ["1/1/2021", "08:00", "09:00", "1h", "10km", "Place A", "Place B", "Paved", "Sunny", "Light"]
        ]
        
        for (rowIndex, row) in data.enumerated() {
            for (columnIndex, item) in row.enumerated() {
                let itemAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.black
                ]
                let frame = CGRect(x: CGFloat(columnIndex) * columnWidth, y: CGFloat(rowIndex + 1) * rowHeight, width: columnWidth, height: rowHeight)
                context.setFillColor(UIColor.white.cgColor)
                context.fill(frame)
                let textRect = frame.insetBy(dx: 2, dy: 2)
                item.draw(in: textRect, withAttributes: itemAttributes)
            }
        }
        
        context.restoreGState()
    }
    
    func savePDF(data: Data) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pdfPath = documentDirectory.appendingPathComponent("DayTimeLog2page.pdf")
            do {
                try data.write(to: pdfPath)
                print("PDF created at: \(pdfPath)")
            } catch {
                print("Could not save PDF: \(error)")
            }
        }
    }
}
