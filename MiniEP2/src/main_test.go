package main

import "testing"

func TestPi(t *testing.T) {
	have := pi(2022, 1e7)
	var want float64 = 3.14159
	var tol float64 = 0.003
	if !((want-tol <= have) && (have <= want+tol)) {
		t.Fatalf("expected %f +- %f, got %f", want, tol, have)
	}
}

func BenchmarkPi(b *testing.B) {
	for i := 0; i < b.N; i++ {
		pi(2022, 1e7)
	}
}
