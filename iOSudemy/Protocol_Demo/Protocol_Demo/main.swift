protocol CanFly {
	func fly()
	
}

class Bird {
	
	var isFemale = true
	
	func layEgg() {
		if isFemale {
				print("The bird makes a new bird in a shell.")
		}
	}

}

class Eagle: Bird, CanFly {
	func fly() {
		print("The eagle flaps its wings and lifts off into the sky.")
	}
	
	func soar() {
		print("The eagle glides in the air using air currents.")
	}
}


class Penguin: Bird {
	func swim() {
		print("The penguin paddles through the water.")
	}
}

struct FlyingMuseum {
	func flyingDemo(flyingObject: CanFly) {
		flyingObject.fly()
	}
}

class Airplane: CanFly {
	
	func fly() {
		print("The airplane uses its engine to lift off into the air.")
	}
}

let myEagle = Eagle()
//myEagle.fly()
//myEagle.layEgg()
//myEagle.soar()
//
let myPenguin = Penguin()
//myPenguin.layEgg()
//myPenguin.swim()
//myPenguin.fly()

let museum = FlyingMuseum()
//museum.flyingDemo(flyingObject: myPenguin)
museum.flyingDemo(flyingObject: myEagle)

let myPlane = Airplane()
museum.flyingDemo(flyingObject: myPlane)

