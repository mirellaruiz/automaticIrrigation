//
//  TankModel.swift
//  Riego Automático
//
//  Created by María Ortega on 28/09/2017.
//  Copyright © 2017 g743 DIT UPM. All rights reserved.
//

import Foundation

class TankModel {
    let tankRadius : Double = 1.5 //VALOR POR DEFECTO
    let pipeRadius : Double =  0.1 //si quieres poner slider para variarlos se pone var
    let g = 9.8 //en vez de crear g en todos los modelos te puedes crear clase con la constante static let g
    let initialWaterHeight = 4.0
    
    private let areaTank: Double //variables aux para reducir formula final
    private let areaPipe: Double
    let timeToEmpty: Double
    init(){
        areaTank = Double.pi * pow(tankRadius,2)
        areaPipe = Double.pi * pow(pipeRadius,2)
        timeToEmpty = sqrt(2*initialWaterHeight*(pow(areaTank/areaPipe,2)-1)/g)
        //timetoempty, areapipe
    }
    
    //devuelve la velocidad de descenso del agua en funcion de la altura del deposito
    func waterSpeedHeight(height: Double)-> Double {
        let v = sqrt(2*g*height/(pow(areaTank/areaPipe,2)-1))
        return max(0,v)//por si no se puede devolver valor, raices negativas etc
    }
    //devuelve la velocidad de salida del agua en funcion de la altura del tanque
    func outputSpeedHeight(height: Double)-> Double {
        let v = sqrt(2*g*height/(1-pow(areaPipe/areaTank,2)))
        return max(0,v)//por si no se puede devolver valor, raices negativas etc
        
    }
    func waterHeightAt(time t: Double) -> Double {
        if t > timeToEmpty {return 0}
        let c0 = initialWaterHeight
        let c1 = -sqrt(2*g*c0/(pow(areaTank/areaPipe,2)-1))
        let c2 = g/(2*(pow(areaTank/areaPipe,2)-1))
        if c1.isNaN{
            return 0
            }
        return c0 + c1*t + c2*t*t
    }
}
