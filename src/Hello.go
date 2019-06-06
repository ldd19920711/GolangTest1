package main

import (
	"fmt"
	"math"
)

//var x, y int
//var (
//	a int
//	b bool
//)
//var c, d int = 1, 2
//var e, f = 123, "hello"
const (
	Unknow = 0
	Male   = 1
	Remale = 2
)

func main() {
	/*注释*/
	//注释
	fmt.Println("Hello, World!")
	//var age int = 1
	//fmt.Println(age)
	//var b bool = true
	//fmt.Println(b)
	//var x float32
	//fmt.Println(x)
	//var y float64
	//fmt.Println(y)
	//var z string
	//fmt.Println(z)
	//g := false
	//fmt.Println(g)
	//var a int = 1
	//fmt.Println(&a)
	//const str = "Hello Go"
	//fmt.Println(str)
	//switch 0 {
	//case Unknow:
	//	break
	//case Male:
	//	break
	//case Remale:
	//	break
	//}
	//const (
	//	a = iota //0
	//	b        //1
	//	c        //2
	//	d = "ha" //独立值，iota += 1
	//	e        //"ha"   iota += 1
	//	f = 100  //iota +=1
	//	g        //100  iota +=1
	//	h = iota //7,恢复计数
	//	i        //8
	//)
	//fmt.Println(a, b, c, d, e, f, g, h, i)
	//var c1, c2, c3 chan int
	//var i1, i2 int
	//select {
	//case i1 = <-c1:
	//	fmt.Printf("received ", i1, " from c1\n")
	//case c2 <- i2:
	//	fmt.Printf("sent ", i2, " to c2\n")
	//case i3, ok := (<-c3): // same as: i3, ok := <-c3
	//	if ok {
	//		fmt.Printf("received ", i3, " from c3\n")
	//	} else {
	//		fmt.Printf("c3 is closed\n")
	//	}
	//default:
	//	fmt.Printf("no communication\n")
	//}
	//var b int = 15
	//var a int
	//numbers := [6]int{1, 2, 3, 5}
	//for a := 0; a < 10; a++ {
	//	fmt.Printf("a的值为: %d\n", a)
	//}
	//for a < b {
	//	a++
	//	fmt.Printf("a的值为: %d\n", a)
	//}
	//for index, value := range numbers {
	//	fmt.Printf("第 %d 位 x 的值 = %d\n", index, value)
	//}
	//打印1..5 1..5
	//for i := 0; i < 5; i++ {
	//	if i == 3 {
	//		continue
	//	}
	//	for j := 0; j < 5; j++ {
	//		fmt.Printf("i=%d,j=%d\n", i, j)
	//	}
	//}
	//var a = 1
	//var b = 2
	//fmt.Printf("a + b = %d\n", sum(a, b))
	//fmt.Println(max(a, b))
	//var c = "World"
	//var d = "Hello"
	//e, f := swap(c, d)
	//fmt.Println(e, f)
	//swap2:= func (a , b string) (string, string) {
	//	return b, a
	//}
	//s, i := swap2("W", "H")
	//fmt.Println(s,i)
	//getSquareRoot :=func(x float64)float64{
	//	return math.Sqrt(x)
	//}
	//fmt.Println(getSquareRoot2(3))
	//sequence := getSequence()
	//fmt.Println(sequence())
	//fmt.Println(sequence())
	//fmt.Println(sequence())
	//var a = 1
	//var b = 2
	//fmt.Printf("交换前: a=%d,b=%d\n", a, b)
	//swapInt(&a, &b)
	//fmt.Printf("交换后: a=%d,b=%d\n", a, b)
	//fmt.Println(&a)
	var balance = [5]int{1,0xf,3}
	fmt.Println(balance)
}

func swapInt(a, b *int) {
	var temp int
	temp = *a
	*a = *b
	*b = temp
}

func getSequence() func() int {
	i := 0
	return func() int {
		i++
		return i
	}
}

var getSquareRoot2 = func(x float64) float64 {
	return math.Sqrt(x)
}

func swap(a, b string) (string, string) {
	return b, a
}

/*求和函数*/
func sum(a int, b int) int {
	return a + b
}

func max(a, b int) int {
	var max = a
	if b > a {
		max = b
	}
	return max
}
