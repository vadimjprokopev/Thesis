
public class Power implements Derivable {
	
	public Power(Derivable a, Derivable b) {
		this.a = a;
		this.b = b;
	}
	
	Derivable a;
	Derivable b;
	
	@Override
	public Derivable derive() {
		if (a.getClass() == E.class) {
			return new Product(new Power(a, b), b.derive());
		} else {
			return new Product(new Product(b, new Log(a)).derive(), new Power(a, b));
		}
	}

	@Override
	public Derivable simplify() {
		
		Derivable aSimple = a.simplify();
		Derivable bSimple = b.simplify();
		
		if(bSimple.equals(new Const(0))) {
			return new Const(1);
		} else if(bSimple.equals(new Const(1))) {
			return aSimple;
		} else {
			a = aSimple;
			b = bSimple;
			return this;
		}
	}
	
	@Override
	public String toString() {
		return a + " ^ " + b;
	}
}
