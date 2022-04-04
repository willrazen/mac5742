package pi

import "testing"

const want float64 = 3.14159
const tol float64 = 0.003

func piCheck(have float64) bool {
	return (want-tol <= have) && (have <= want+tol)
}

func TestOriginal(t *testing.T) {
	have := Original(2022, 1e7)
	if !piCheck(have) {
		t.Errorf("expected %f +- %f, got %f", want, tol, have)
	}
}

func BenchmarkOriginal(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Original(2022, 1e7)
	}
}

func TestUnroll4(t *testing.T) {
	have := Unroll4(2022, 1e7)
	if !piCheck(have) {
		t.Errorf("expected %f +- %f, got %f", want, tol, have)
	}
}

func BenchmarkUnroll4(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Unroll4(2022, 1e7)
	}
}

func TestUnroll10(t *testing.T) {
	have := Unroll10(2022, 1e7)
	if !piCheck(have) {
		t.Errorf("expected %f +- %f, got %f", want, tol, have)
	}
}

func BenchmarkUnroll10(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Unroll10(2022, 1e7)
	}
}

func TestXoroshiro(t *testing.T) {
	have := Xoroshiro(2022, 1e7)
	if !piCheck(have) {
		t.Errorf("expected %f +- %f, got %f", want, tol, have)
	}
}

func BenchmarkXoroshiro(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Xoroshiro(2022, 1e7)
	}
}

func TestSplitmix(t *testing.T) {
	have := Splitmix(2022, 1e7)
	if !piCheck(have) {
		t.Errorf("expected %f +- %f, got %f", want, tol, have)
	}
}

func BenchmarkSplitmix(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Splitmix(2022, 1e7)
	}
}

func TestBest(t *testing.T) {
	have := Best(2022, 1e7)
	if !piCheck(have) {
		t.Errorf("expected %f +- %f, got %f", want, tol, have)
	}
}

func BenchmarkBest(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Best(2022, 1e7)
	}
}
