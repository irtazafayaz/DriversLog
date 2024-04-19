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
            
            // This function should be filled with additional pages and content as needed
        }
        
        savePDF(data: data)
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
