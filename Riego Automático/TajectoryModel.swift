//
//  TajectoryModel.swift
//  Riego Automático
//
//  Created by María Ortega on 28/09/2017.
//  Copyright © 2017 g743 DIT UPM. All rights reserved.
//

import Foundation
class TrajectoryModel{
    let g = 9.8
    var originPos = (x: 0.0, y:0.0){
        //llamamos a update para que en cuanto alguien cambie las constantes se actualizen
        didSet{
            update()
        }
    }
    //posicion destino
    var targetPos = (x:0.0, y:0.0){
        didSet{
            update()
        }
    }
   //velocidad inicial
    var speed: Double = 0.0 {
        didSet{
            update()
        }
    }
    //si se cambia posicion final o speed hay que actualizar vx vy y angle, creamos funcion update
    private var angle: Double = 0.0
    private var speedX = 0.0
    private var speedY = 0.0
    private func update(){
        let xf = targetPos.x - originPos.x
        let yf = targetPos.y - originPos.y
        angle = atan((pow(speed,2 ) + sqrt(pow(speed, 4) - pow(g*xf,2) - 2*g*yf*pow(speed, 2)))/(g*xf))
        print(angle)
        if !angle.isNormal{
            print("yess")
            speedX = 0
            speedY = 0
        }
        else {
            speedX = speed * cos(angle)
            speedY = speed * sin(angle)
        }
    }
        //Tiempo que tarda en llegar a la posicion destino
        func timeToTarget()->Double?{
            let t = (targetPos.x - originPos.x)/speedX
            return t
        }
        func positionAt(time:Double)-> (x:Double, y:Double){
            let x = originPos.x + speedX * time
            let y = originPos.y + speedY*time - 0.5*g*pow(time,2)
            return (x,y)
        }
}
