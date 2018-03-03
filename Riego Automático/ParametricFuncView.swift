//
//  ParametricFuncView.swift
//  Riego Automático
//
//  Created by g743 DIT UPM on 26/9/17.
//  Copyright © 2017 g743 DIT UPM. All rights reserved.
//

import UIKit

//CREACION TIPO PUNTO

struct FunctionPoint{
    var x = 0.0
    var y = 0.0
}

//DEFINICION DEL PROTOCOLO/INTERFAZ PARA COMUNICAR A LA VIEW CON EL CONTROLLER
protocol ParametricFuncDataSource: class{
    func startFor(_ pfv: ParametricFuncView)-> Double
    func endFor(_ pfv: ParametricFuncView)-> Double
    func parametricFuncView(_ pfv: ParametricFuncView, pointAt index: Double)-> FunctionPoint
}


@IBDesignable
class ParametricFuncView: UIView {
    //CONFIGURACION DE LA VAR DATASOURCE PARA USAR LOS METODOS DEL PROTOCOLO
    //esto en realidad es para crear una falsa datasoruce porque el  draw se esta compilando antes ejecutarse el proyecto, por tanto el datasource esta vacio, de esta forma hay un objeto y no devulve nil
    #if TARGET_INTERFACE_BUILDER
    var  dataSource: ParametricFuncDataSource!
    #else
    weak var  dataSource: ParametricFuncDataSource!
    #endif
    override func prepareForInterfaceBuilder() {
        
        class FakeDataSource: ParametricFuncDataSource {
            //llamarlas igual o no??
            func startFor(_ pfv: ParametricFuncView) -> Double {
                return 0.0
            }
            func endFor(_ pfv: ParametricFuncView) -> Double {
                return 1.0
            }
            func parametricFuncView(_ pfv: ParametricFuncView, pointAt index: Double) -> FunctionPoint {
                return FunctionPoint(x:index, y:index)
            }
        }
        dataSource = FakeDataSource()
    }
    /*
    @IBInspectable
    var lineWidth :  Double = 3.0
    */
    var scaleX: Double = 50.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    var scaleY: Double = 15.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    //DIBUJAR EJES CENTRADOS
    private func drawAxis() {
        let w = bounds.width
        let h = bounds.height
        
        let pathY = UIBezierPath()
        pathY.move(to: CGPoint(x: w/2, y: 0))
        pathY.addLine(to: CGPoint(x: w/2, y: h))
        let pathX = UIBezierPath()
        pathX.move(to: CGPoint(x: 0, y: h/2))
        pathX.addLine(to: CGPoint(x: w, y: h/2))
        
        pathY.lineWidth = 2
        UIColor.black.setStroke()
        pathY.stroke()
        
        pathX.lineWidth = 2
        UIColor.black.setStroke()
        pathX.stroke()
    }
    
    
    //DIBUJAR TRAYECTORIA DE LA FUNCION
    private func drawTrajectory() {
        let p0 = dataSource.startFor(self)
        let pf = dataSource.endFor(self)
        let dp = (pf - p0)/100
        //v0 es (0, f(0))
        let v0 = dataSource.parametricFuncView(self, pointAt: p0)
        let ptx0 = pointForX(v0.x)
        let pty0 = pointForY(v0.y)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: ptx0, y:pty0))
        // resto de puntos (p, f(p))
        if (pf != 0){
        for p in stride(from:p0, to:pf, by:dp){
            let v = dataSource.parametricFuncView(self, pointAt:p)
            let ptx = pointForX(v.x)
            let pty = pointForY(v.y)
            path.addLine(to: CGPoint(x:ptx, y:pty))
        }
        
    }
        path.lineWidth = 2
        UIColor.red.setStroke()
        path.stroke()
    }
    //dibujar todo
    override func draw(_ rect: CGRect) {
    drawAxis()
    drawTrajectory()
    //drawPOI()//PUNTOSDEINTERES
    }
    /*
    drawPOI
        for p in dataSource.pointsOfinterestFor(self){
            let px = pointForX(p.x)
            let py=pointForY(p.y)
            leth path = UIBezierPath(ovalIn: CGRect(x: px-4, y: py-4, width: 8, height: 8))
            UIColor.red.set()
            path.stroke()
            path.fill()
    }
 */
    //funciones de escalado
    private func pointForX(_ x: Double) -> CGFloat {
        let width = bounds.width
        return (width/2) + CGFloat(x*scaleX)
    }
    private func pointForY(_ y: Double) -> CGFloat {
        let height = bounds.height
        return (height/2) - CGFloat(y*scaleY)
    }}
