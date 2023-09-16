//
// Created By: Mobile Apps Academy
// Subscribe : https://www.youtube.com/@MobileAppsAcademy?sub_confirmation=1
// Medium Blob : https://medium.com/@mobileappsacademy
// LinkedIn : https://www.linkedin.com/company/mobile-apps-academy
// Twitter : https://twitter.com/MobileAppsAcdmy
// Lisence : https://github.com/Mobile-Apps-Academy/MobileAppsAcademyLicense/blob/main/LICENSE.txt
//


import SwiftUI

struct MorphingDragView<RenderShape: Shape>: View {
    @ViewBuilder var shape: RenderShape
    @State var dragValue: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack {
                DragView()
            }
        }
        .background(Color("Grey"))
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func BlobShape(offset: CGSize = .zero) -> some View {
        shape.fill(Color("Yellow")).frame(width: 150, height: 150).offset(offset)
    }
    
    @ViewBuilder
    func DragView() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [Color("Yellow"), .white], startPoint: .top, endPoint: .bottom))
                .mask({
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.5, color: .red))
                        
                        context.addFilter(.blur(radius: 30))
                        
                        context.drawLayer { ctx in
                            // Selecting 1 and 2 as we will have two shapes
                            for index in [1, 2] {
                                if let resolvedView = context.resolveSymbol(id: index) {
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                }
                            }
                        }
                    }symbols: {
                        BlobShape().tag(1)
                        BlobShape(offset: dragValue).tag(2)
                    }
                    
                })
                .gesture(
                    DragGesture().onChanged({ value in
                        dragValue = value.translation
                    }).onEnded({ _ in
                        withAnimation (
                            .interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                dragValue = .zero
                            }
                    })
                )
    }
    
}

struct MorphingDragView_Previews: PreviewProvider {
    static var previews: some View {
        MorphingDragView{
            Rectangle()
        }
    }
}
