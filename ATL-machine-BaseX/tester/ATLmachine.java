package tester;

public class ATLmachine {
	
	static public void atl(String IMM,String IMN, String OMM, String OMN, String IM, String OM, String TD, String T)
	{
		ATLLauncher.atl(IMM, IMN, OMM, OMN, IM, OM, TD, T);
	};
	
    static public void main(String[] args)
    {
	ATLLauncher.atl("Composed.ecore","Composed","Simple.ecore","Simple",
			"composed.xmi","simple.xmi","./","Composed2Simple");

    }
}