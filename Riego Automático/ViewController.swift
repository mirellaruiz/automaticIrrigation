//
//  ViewController.swift
//  Riego Automático
//
//  Created by g743 DIT UPM on 26/9/17.
//  Copyright © 2017 g743 DIT UPM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ParametricFuncDataSource {
    //crear objetos tipo tanque y tipo trayectoria, si hubiera varios tiestos pues varios objetos trayectoria
    var tankModel : TankModel!
    var trajectoryModel : TrajectoryModel!
    
    @IBOutlet weak var trajectoryGra: ParametricFuncView!
    @IBOutlet weak var outputSpeedHeightGra: ParametricFuncView!
    @IBOutlet weak var waterSpeedHeightGra: ParametricFuncView!
    @IBOutlet weak var waterAtTimeGra: ParametricFuncView!
    
    @IBOutlet weak var timeSlider: UISlider!
   //Otro slider
    
    var trajectoryTime: Double = 0.0{
        didSet{
         
            trajectoryGra.setNeedsDisplay() //para que al modificar el slider se repinten las graficas
            outputSpeedHeightGra.setNeedsDisplay()
            waterSpeedHeightGra.setNeedsDisplay()
            waterAtTimeGra.setNeedsDisplay()
        }
    
    }
   @IBAction func timeChanged(_ sender: UISlider) {
       trajectoryTime =  200 * Double(sender.value)
 print(trajectoryTime)
    //PONE OTRA VEZ LOS SET NEEDS DISPLAY
    }

    
    //desarrollo de las funciones de la interfaz/protocolo
    
    func startFor(_ pfv: ParametricFuncView) -> Double {
        if pfv == trajectoryGra { print("timeemp", tankModel.timeToEmpty)
            return 0}
        else if pfv == outputSpeedHeightGra {return 0}
        else if pfv == waterSpeedHeightGra {return 0}
        else if pfv == waterAtTimeGra {return 0}
        else  {return 0}
    }
 
    func endFor(_ pfv: ParametricFuncView) -> Double {
        //la que pone la velocidad en funcion del tiempo, punto final el timetoempty, la vel salida segun la altura del tanque pues punto final la altura del tanque, la de la trayectoria pregunta altura y velocidad y calcula timetotarget
        if pfv == trajectoryGra {
        let h = tankModel.waterHeightAt(time: trajectoryTime)
        let v = tankModel.outputSpeedHeight(height: h)
            print(v)
        trajectoryModel.speed = v
            let m = trajectoryModel.timeToTarget()!
            print("End For trayectory", m)
            return m
            
        
        }
        else if pfv == outputSpeedHeightGra {
            //RETURN MIN DE TIME TO EMPTY O TRAJECTORY TIME
            print("End For output", trajectoryTime)
            return min(tankModel.timeToEmpty, trajectoryTime)}
        else if pfv == waterSpeedHeightGra {
            let m = tankModel.initialWaterHeight
            print("End For waterSpeed", m)
            return min(tankModel.timeToEmpty, trajectoryTime)}
        else if pfv == waterAtTimeGra {
            let m = tankModel.timeToEmpty
            print("End For waterTime", m)
            return min(tankModel.timeToEmpty, trajectoryTime)}
        else  {
            print("End for default")
            return 0}
    }
    
    func parametricFuncView(_ pfv: ParametricFuncView, pointAt index: Double) -> FunctionPoint {
        switch pfv {
        case trajectoryGra:
        // DUDA: tambien se actualiza v en endFor?
         //let time = index
         //let h = tankModel.waterHeightAt (time: time)
         //let v = tankModel.outputSpeedHeight(height: h)
         //trajectoryModel.speed = v
         let x = trajectoryModel.positionAt(time: index).x
         let y = trajectoryModel.positionAt(time: index).y
         print("tray", x, y)
         return FunctionPoint(x:x, y:y)
            
        case outputSpeedHeightGra:
        let time = index
        let h = tankModel.waterHeightAt (time: time)
        let v = tankModel.outputSpeedHeight(height: h)
        //print("output", h, v)
        return FunctionPoint(x:h, y:v)
        
        case waterSpeedHeightGra:
            let time = index
            let h = tankModel.waterHeightAt (time: time)
            let v = tankModel.waterSpeedHeight(height: h)
            //print("watspeed", h, v)
            return FunctionPoint(x:h, y: v)
        
        case waterAtTimeGra:
            let h = tankModel.waterHeightAt(time: index)
            //print("wattime", index, h)
            return FunctionPoint(x:index, y:h)
        default:
            //print("default")
            return FunctionPoint(x: 0.0, y: 0.0)
        }
    }
        //ha añadido al protocolo esta funcion
       /* func pointsOfInterestFor( _pfv: ParametricFuncView)-> [FuntionPoint]{
            switch pfv{
                case pfv1:
                default: return[]
            }
        }*/
  //funcion de iniciacion
    //esto esta ya bien
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tankModel = TankModel()
        trajectoryModel = TrajectoryModel()
       
       
        
        trajectoryGra.dataSource = self //una por grafica, esto esta bien creo
        outputSpeedHeightGra.dataSource = self
        waterSpeedHeightGra.dataSource = self
        waterAtTimeGra.dataSource = self
        
        
    
        trajectoryModel.originPos = (0,2)
        trajectoryModel.targetPos = (2.0,0)
        timeSlider.sendActions(for: .valueChanged)
       
        trajectoryGra.scaleX = 40.0
        trajectoryGra.scaleY = 10.0
        
        outputSpeedHeightGra.scaleX = 25.0
        outputSpeedHeightGra.scaleY = 5.0
        
        waterAtTimeGra.scaleX = 0.5
        waterAtTimeGra.scaleY = 15.0
        
        waterSpeedHeightGra.scaleX = 25.0
        waterSpeedHeightGra.scaleY = 1000.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

