//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let g = 9.8
func calcularTrayectoria(_ pf: CGPoint, _ v: Double){
    var tf,vx,vy,a1, a2
  //dudita que angulo cogemos
    a1 = arctag(v^2+sqrt((v^4)-(g^2*(pf.x)^2)-(2*g*pf.y*v^2))/(g*pf.x))
    
  a2 = arctag(v^2-sqrt((v^4)-(g^2*(pf.x)^2)-(2*g*pf.y*v^2))/(g*pf.x))}

vx=v*cos(a1)
vy=v*sin(a1)
tf=xf/vx
a=arctan(v^2)
