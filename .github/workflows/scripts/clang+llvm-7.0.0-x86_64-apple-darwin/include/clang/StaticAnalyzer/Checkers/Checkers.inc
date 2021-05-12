
#ifdef GET_GROUPS
#endif // GET_GROUPS


#ifdef GET_PACKAGES
PACKAGE("alpha", -1, false)
PACKAGE("alpha.clone", -1, true)
PACKAGE("alpha.core", -1, true)
PACKAGE("alpha.cplusplus", -1, true)
PACKAGE("alpha.deadcode", -1, true)
PACKAGE("alpha.osx", -1, true)
PACKAGE("alpha.osx.cocoa", -1, true)
PACKAGE("alpha.osx.cocoa.localizability", -1, true)
PACKAGE("alpha.security", -1, true)
PACKAGE("alpha.security.taint", -1, true)
PACKAGE("alpha.unix", -1, true)
PACKAGE("alpha.unix.cstring", -1, true)
PACKAGE("apiModeling", -1, true)
PACKAGE("apiModeling.google", -1, true)
PACKAGE("core", -1, false)
PACKAGE("core.builtin", -1, false)
PACKAGE("core.uninitialized", -1, false)
PACKAGE("cplusplus", -1, false)
PACKAGE("deadcode", -1, false)
PACKAGE("debug", -1, false)
PACKAGE("llvm", -1, false)
PACKAGE("nullability", -1, false)
PACKAGE("optin", -1, false)
PACKAGE("optin.cplusplus", -1, false)
PACKAGE("optin.mpi", -1, false)
PACKAGE("optin.osx", -1, false)
PACKAGE("optin.osx.cocoa", -1, false)
PACKAGE("optin.osx.cocoa.localizability", -1, false)
PACKAGE("optin.performance", -1, false)
PACKAGE("optin.portability", -1, false)
PACKAGE("osx", -1, false)
PACKAGE("osx.cocoa", -1, false)
PACKAGE("osx.coreFoundation", -1, false)
PACKAGE("osx.coreFoundation.containers", -1, false)
PACKAGE("security", -1, false)
PACKAGE("security.insecureAPI", -1, false)
PACKAGE("unix", -1, false)
PACKAGE("unix.cstring", -1, true)
PACKAGE("valist", -1, false)
#endif // GET_PACKAGES


#ifdef GET_CHECKERS
CHECKER("debug.AnalysisOrder", AnalysisOrderChecker, AnalysisOrder.cpp, "Print callbacks that are called during analysis in order", -1, false)
CHECKER("debug.Stats", AnalyzerStatsChecker, AnalyzerStatsChecker.cpp, "Emit warnings with analyzer statistics", -1, false)
CHECKER("alpha.security.ArrayBound", ArrayBoundChecker, ArrayBoundChecker.cpp, "Warn about buffer overflows (older checker)", -1, true)
CHECKER("alpha.security.ArrayBoundV2", ArrayBoundCheckerV2, ArrayBoundCheckerV2.cpp, "Warn about buffer overflows (newer checker)", -1, true)
CHECKER("osx.cocoa.AutoreleaseWrite", AutoreleaseWriteChecker, ObjCAutoreleaseWriteChecker.cpp, "Warn about potentially crashing writes to autoreleasing objects from different autoreleasing pools in Objective-C", -1, false)
CHECKER("alpha.unix.BlockInCriticalSection", BlockInCriticalSectionChecker, BlockInCriticalSectionChecker.cpp, "Check for calls to blocking functions inside a critical section", -1, true)
CHECKER("alpha.core.BoolAssignment", BoolAssignmentChecker, BoolAssignmentChecker.cpp, "Warn about assigning non-{0,1} values to Boolean variables", -1, true)
CHECKER("core.builtin.BuiltinFunctions", BuiltinFunctionChecker, BuiltinFunctionChecker.cpp, "Evaluate compiler builtin functions (e.g., alloca())", -1, false)
CHECKER("osx.coreFoundation.CFError", CFErrorChecker, NSErrorChecker.cpp, "Check usage of CFErrorRef* parameters", -1, false)
CHECKER("debug.DumpCFG", CFGDumper, DebugCheckers.cpp, "Display Control-Flow Graphs", -1, false)
CHECKER("debug.ViewCFG", CFGViewer, DebugCheckers.cpp, "View Control-Flow Graphs using GraphViz", -1, false)
CHECKER("osx.coreFoundation.CFNumber", CFNumberChecker, BasicObjCFoundationChecks.cpp, "Check for proper uses of CFNumber APIs", -1, false)
CHECKER("osx.coreFoundation.CFRetainRelease", CFRetainReleaseChecker, BasicObjCFoundationChecks.cpp, "Check for null arguments to CFRetain/CFRelease/CFMakeCollectable", -1, false)
CHECKER("alpha.unix.cstring.BufferOverlap", CStringBufferOverlap, CStringChecker.cpp, "Checks for overlap in two buffer arguments", -1, true)
CHECKER("alpha.unix.cstring.NotNullTerminated", CStringNotNullTerm, CStringChecker.cpp, "Check for arguments which are not null-terminating strings", -1, true)
CHECKER("unix.cstring.NullArg", CStringNullArg, CStringChecker.cpp, "Check for null pointers being passed as arguments to C string functions", -1, true)
CHECKER("alpha.unix.cstring.OutOfBounds", CStringOutOfBounds, CStringChecker.cpp, "Check for out-of-bounds access in string functions", -1, true)
CHECKER("unix.cstring.BadSizeArg", CStringSyntaxChecker, CStringSyntaxChecker.cpp, "Check the size argument passed into C string functions for common erroneous patterns", -1, true)
CHECKER("cplusplus.SelfAssignment", CXXSelfAssignmentChecker, CXXSelfAssignmentChecker.cpp, "Checks C++ copy and move assignment operators for self assignment", -1, false)
CHECKER("core.CallAndMessage", CallAndMessageChecker, CallAndMessageChecker.cpp, "Check for logical errors for function calls and Objective-C message expressions (e.g., uninitialized arguments, null function pointers)", -1, false)
CHECKER("alpha.core.CallAndMessageUnInitRefArg", CallAndMessageUnInitRefArg, CallAndMessageChecker.cpp, "Check for logical errors for function calls and Objective-C message expressions (e.g., uninitialized arguments, null function pointers, and pointer to undefined variables)", -1, true)
CHECKER("debug.DumpCalls", CallDumper, TraversalChecker.cpp, "Print calls as they are traversed by the engine", -1, false)
CHECKER("debug.DumpCallGraph", CallGraphDumper, DebugCheckers.cpp, "Display Call Graph", -1, false)
CHECKER("debug.ViewCallGraph", CallGraphViewer, DebugCheckers.cpp, "View Call Graph using GraphViz", -1, false)
CHECKER("alpha.core.CastSize", CastSizeChecker, CastSizeChecker.cpp, "Check when casting a malloc'ed type T, whether the size is a multiple of the size of T", -1, true)
CHECKER("alpha.core.CastToStruct", CastToStructChecker, CastToStructChecker.cpp, "Check for cast from non-struct pointer to struct pointer", -1, true)
CHECKER("alpha.unix.Chroot", ChrootChecker, ChrootChecker.cpp, "Check improper use of chroot", -1, true)
CHECKER("osx.cocoa.ClassRelease", ClassReleaseChecker, BasicObjCFoundationChecks.cpp, "Check for sending 'retain', 'release', or 'autorelease' directly to a Class", -1, false)
CHECKER("alpha.clone.CloneChecker", CloneChecker, CloneChecker.cpp, "Reports similar pieces of code.", -1, true)
CHECKER("debug.ConfigDumper", ConfigDumper, DebugCheckers.cpp, "Dump config table", -1, false)
CHECKER("alpha.core.Conversion", ConversionChecker, ConversionChecker.cpp, "Loss of sign/precision in implicit conversions", -1, true)
CHECKER("valist.CopyToSelf", CopyToSelfChecker, ValistChecker.cpp, "Check for va_lists which are copied onto itself.", -1, false)
CHECKER("deadcode.DeadStores", DeadStoresChecker, DeadStoresChecker.cpp, "Check for values stored to variables that are never read afterwards", -1, false)
CHECKER("alpha.cplusplus.DeleteWithNonVirtualDtor", DeleteWithNonVirtualDtorChecker, DeleteWithNonVirtualDtorChecker.cpp, "Reports destructions of polymorphic objects with a non-virtual destructor in their base class", -1, true)
CHECKER("core.NullDereference", DereferenceChecker, DereferenceChecker.cpp, "Check for dereferences of null pointers", -1, false)
CHECKER("alpha.osx.cocoa.DirectIvarAssignment", DirectIvarAssignment, DirectIvarAssignment.cpp, "Check for direct assignments to instance variables", -1, true)
CHECKER("alpha.osx.cocoa.DirectIvarAssignmentForAnnotatedFunctions", DirectIvarAssignmentForAnnotatedFunctions, DirectIvarAssignment.cpp, "Check for direct assignments to instance variables in the methods annotated with objc_no_direct_instance_variable_assignment", -1, true)
CHECKER("core.DivideZero", DivZeroChecker, DivZeroChecker.cpp, "Check for division by zero", -1, false)
CHECKER("debug.DumpDominators", DominatorsTreeDumper, DebugCheckers.cpp, "Print the dominance tree for a given CFG", -1, false)
CHECKER("alpha.core.DynamicTypeChecker", DynamicTypeChecker, DynamicTypeChecker.cpp, "Check for cases where the dynamic and the static type of an object are unrelated.", -1, true)
CHECKER("core.DynamicTypePropagation", DynamicTypePropagation, DynamicTypePropagation.cpp, "Generate dynamic type information", -1, false)
CHECKER("optin.osx.cocoa.localizability.EmptyLocalizationContextChecker", EmptyLocalizationContextChecker, LocalizationChecker.cpp, "Check that NSLocalizedString macros include a comment for context", -1, false)
CHECKER("debug.ViewExplodedGraph", ExplodedGraphViewer, DebugCheckers.cpp, "View Exploded Graphs using GraphViz", -1, false)
CHECKER("debug.ExprInspection", ExprInspectionChecker, ExprInspectionChecker.cpp, "Check the analyzer's understanding of expressions", -1, false)
CHECKER("alpha.core.FixedAddr", FixedAddressChecker, FixedAddressChecker.cpp, "Check for assignment of a fixed address to a pointer", -1, true)
CHECKER("security.FloatLoopCounter", FloatLoopCounter, CheckSecuritySyntaxOnly.cpp, "Warn on using a floating point value as a loop counter (CERT: FLP30-C, FLP30-CPP)", -1, false)
CHECKER("optin.performance.GCDAntipattern", GCDAntipattern, GCDAntipatternChecker.cpp, "Check for performance anti-patterns when using Grand Central Dispatch", -1, false)
CHECKER("apiModeling.google.GTest", GTestChecker, GTestChecker.cpp, "Model gtest assertion APIs", -1, true)
CHECKER("alpha.security.taint.TaintPropagation", GenericTaintChecker, GenericTaintChecker.cpp, "Generate taint information used by other checkers", -1, true)
CHECKER("alpha.core.IdenticalExpr", IdenticalExprChecker, IdenticalExprChecker.cpp, "Warn about unintended use of identical expressions in operators", -1, true)
CHECKER("cplusplus.InnerPointer", InnerPointerChecker, InnerPointerChecker.cpp, "Check for inner pointers of C++ containers used after re/deallocation", -1, false)
CHECKER("alpha.osx.cocoa.InstanceVariableInvalidation", InstanceVariableInvalidation, IvarInvalidationChecker.cpp, "Check that the invalidatable instance variables are invalidated in the methods annotated with objc_instance_variable_invalidator", -1, true)
CHECKER("alpha.cplusplus.IteratorRange", IteratorRangeChecker, IteratorChecker.cpp, "Check for iterators used outside their valid ranges", -1, true)
CHECKER("llvm.Conventions", LLVMConventionsChecker, LLVMConventionsChecker.cpp, "Check code for LLVM codebase conventions", -1, false)
CHECKER("debug.DumpLiveVars", LiveVariablesDumper, DebugCheckers.cpp, "Print results of live variable analysis", -1, false)
CHECKER("optin.mpi.MPI-Checker", MPIChecker, MPIChecker.cpp, "Checks MPI code", -1, false)
CHECKER("osx.SecKeychainAPI", MacOSKeychainAPIChecker, MacOSKeychainAPIChecker.cpp, "Check for proper uses of Secure Keychain APIs", -1, false)
CHECKER("osx.API", MacOSXAPIChecker, MacOSXAPIChecker.cpp, "Check for proper uses of various Apple APIs", -1, false)
CHECKER("unix.Malloc", MallocChecker, MallocChecker.cpp, "Check for memory leaks, double free, and use-after-free problems. Traces memory managed by malloc()/free().", -1, false)
CHECKER("alpha.security.MallocOverflow", MallocOverflowSecurityChecker, MallocOverflowSecurityChecker.cpp, "Check for overflows in the arguments to malloc()", -1, true)
CHECKER("unix.MallocSizeof", MallocSizeofChecker, MallocSizeofChecker.cpp, "Check for dubious malloc arguments involving sizeof", -1, false)
CHECKER("unix.MismatchedDeallocator", MismatchedDeallocatorChecker, MallocChecker.cpp, "Check for mismatched deallocators.", -1, false)
CHECKER("alpha.osx.cocoa.MissingInvalidationMethod", MissingInvalidationMethod, IvarInvalidationChecker.cpp, "Check that the invalidation methods are present in classes that contain invalidatable instance variables", -1, true)
CHECKER("alpha.cplusplus.MisusedMovedObject", MisusedMovedObjectChecker, MisusedMovedObjectChecker.cpp, "Method calls on a moved-from object and copying a moved-from object will be reported", -1, true)
CHECKER("alpha.security.MmapWriteExec", MmapWriteExecChecker, MmapWriteExecChecker.cpp, "Warn on mmap() calls that are both writable and executable", -1, true)
CHECKER("osx.cocoa.NSAutoreleasePool", NSAutoreleasePoolChecker, NSAutoreleasePoolChecker.cpp, "Warn for suboptimal uses of NSAutoreleasePool in Objective-C GC mode", -1, false)
CHECKER("osx.cocoa.NSError", NSErrorChecker, NSErrorChecker.cpp, "Check usage of NSError** parameters", -1, false)
CHECKER("cplusplus.NewDelete", NewDeleteChecker, MallocChecker.cpp, "Check for double-free and use-after-free problems. Traces memory managed by new/delete.", -1, false)
CHECKER("cplusplus.NewDeleteLeaks", NewDeleteLeaksChecker, MallocChecker.cpp, "Check for memory leaks. Traces memory managed by new/delete.", -1, false)
CHECKER("osx.cocoa.NilArg", NilArgChecker, BasicObjCFoundationChecks.cpp, "Check for prohibited nil arguments to ObjC method calls", -1, false)
CHECKER("core.builtin.NoReturnFunctions", NoReturnFunctionChecker, NoReturnFunctionChecker.cpp, "Evaluate \"panic\" functions that are known to not return to the caller", -1, false)
CHECKER("optin.osx.cocoa.localizability.NonLocalizedStringChecker", NonLocalizedStringChecker, LocalizationChecker.cpp, "Warns about uses of non-localized NSStrings passed to UI methods expecting localized NSStrings", -1, false)
CHECKER("core.NonNullParamChecker", NonNullParamChecker, NonNullParamChecker.cpp, "Check for null pointers passed as arguments to a function whose arguments are references or marked with the 'nonnull' attribute", -1, false)
CHECKER("core.NonnilStringConstants", NonnullGlobalConstantsChecker, NonilStringConstantsChecker.cpp, "Assume that const string-like globals are non-null", -1, false)
CHECKER("nullability.NullPassedToNonnull", NullPassedToNonnullChecker, NullabilityChecker.cpp, "Warns when a null pointer is passed to a pointer which has a _Nonnull type.", -1, false)
CHECKER("nullability.NullReturnedFromNonnull", NullReturnedFromNonnullChecker, NullabilityChecker.cpp, "Warns when a null pointer is returned from a function that has _Nonnull return type.", -1, false)
CHECKER("nullability.NullableDereferenced", NullableDereferencedChecker, NullabilityChecker.cpp, "Warns when a nullable pointer is dereferenced.", -1, false)
CHECKER("nullability.NullablePassedToNonnull", NullablePassedToNonnullChecker, NullabilityChecker.cpp, "Warns when a nullable pointer is passed to a pointer which has a _Nonnull type.", -1, false)
CHECKER("nullability.NullableReturnedFromNonnull", NullableReturnedFromNonnullChecker, NullabilityChecker.cpp, "Warns when a nullable pointer is returned from a function that has _Nonnull return type.", -1, false)
CHECKER("osx.NumberObjectConversion", NumberObjectConversionChecker, NumberObjectConversionChecker.cpp, "Check for erroneous conversions of objects representing numbers into numbers", -1, false)
CHECKER("osx.cocoa.AtSync", ObjCAtSyncChecker, ObjCAtSyncChecker.cpp, "Check for nil pointers used as mutexes for @synchronized", -1, false)
CHECKER("osx.coreFoundation.containers.PointerSizedValues", ObjCContainersASTChecker, ObjCContainersASTChecker.cpp, "Warns if 'CFArray', 'CFDictionary', 'CFSet' are created with non-pointer-size values", -1, false)
CHECKER("osx.coreFoundation.containers.OutOfBounds", ObjCContainersChecker, ObjCContainersChecker.cpp, "Checks for index out-of-bounds when using 'CFArray' API", -1, false)
CHECKER("osx.cocoa.Dealloc", ObjCDeallocChecker, CheckObjCDealloc.cpp, "Warn about Objective-C classes that lack a correct implementation of -dealloc", -1, false)
CHECKER("osx.cocoa.ObjCGenerics", ObjCGenericsChecker, DynamicTypePropagation.cpp, "Check for type errors when using Objective-C generics", -1, false)
CHECKER("osx.cocoa.Loops", ObjCLoopChecker, BasicObjCFoundationChecks.cpp, "Improved modeling of loops using Cocoa collection types", -1, false)
CHECKER("osx.cocoa.IncompatibleMethodTypes", ObjCMethSigsChecker, CheckObjCInstMethSignature.cpp, "Warn about Objective-C method signatures with type incompatibilities", -1, false)
CHECKER("osx.cocoa.NonNilReturnValue", ObjCNonNilReturnValueChecker, BasicObjCFoundationChecks.cpp, "Model the APIs that are guaranteed to return a non-nil value", -1, false)
CHECKER("osx.ObjCProperty", ObjCPropertyChecker, ObjCPropertyChecker.cpp, "Check for proper uses of Objective-C properties", -1, false)
CHECKER("osx.cocoa.SelfInit", ObjCSelfInitChecker, ObjCSelfInitChecker.cpp, "Check that 'self' is properly initialized inside an initializer method", -1, false)
CHECKER("osx.cocoa.MissingSuperCall", ObjCSuperCallChecker, ObjCMissingSuperCallChecker.cpp, "Warn about Objective-C methods that lack a necessary call to super", -1, false)
CHECKER("osx.cocoa.SuperDealloc", ObjCSuperDeallocChecker, ObjCSuperDeallocChecker.cpp, "Warn about improper use of '[super dealloc]' in Objective-C", -1, false)
CHECKER("osx.cocoa.UnusedIvars", ObjCUnusedIvarsChecker, ObjCUnusedIVarsChecker.cpp, "Warn about private ivars that are never used", -1, false)
CHECKER("optin.performance.Padding", PaddingChecker, PaddingChecker.cpp, "Check for excessively padded structs.", -1, false)
CHECKER("alpha.osx.cocoa.localizability.PluralMisuseChecker", PluralMisuseChecker, LocalizationChecker.cpp, "Warns against using one vs. many plural pattern in code when generating localized strings.", -1, true)
CHECKER("alpha.core.PointerArithm", PointerArithChecker, PointerArithChecker, "Check for pointer arithmetic on locations other than array elements", -1, true)
CHECKER("alpha.core.PointerSub", PointerSubChecker, PointerSubChecker, "Check for pointer subtractions on two pointers pointing to different memory chunks", -1, true)
CHECKER("alpha.unix.PthreadLock", PthreadLockChecker, PthreadLockChecker.cpp, "Simple lock -> unlock checker", -1, true)
CHECKER("osx.cocoa.RetainCount", RetainCountChecker, RetainCountChecker.cpp, "Check for leaks and improper reference count management", -1, false)
CHECKER("alpha.security.ReturnPtrRange", ReturnPointerRangeChecker, ReturnPointerRangeChecker.cpp, "Check for an out-of-bound pointer being returned to callers", -1, true)
CHECKER("core.uninitialized.UndefReturn", ReturnUndefChecker, ReturnUndefChecker.cpp, "Check for uninitialized values being returned to the caller", -1, false)
CHECKER("osx.cocoa.RunLoopAutoreleaseLeak", RunLoopAutoreleaseLeakChecker, RunLoopAutoreleaseLeakChecker.cpp, "Check for leaked memory in autorelease pools that will never be drained", -1, false)
CHECKER("alpha.unix.SimpleStream", SimpleStreamChecker, SimpleStreamChecker.cpp, "Check for misuses of stream APIs", -1, true)
CHECKER("alpha.core.SizeofPtr", SizeofPointerChecker, CheckSizeofPointer.cpp, "Warn about unintended use of sizeof() on pointer expressions", -1, true)
CHECKER("alpha.core.StackAddressAsyncEscape", StackAddrAsyncEscapeChecker, StackAddrEscapeChecker.cpp, "Check that addresses to stack memory do not escape the function", -1, true)
CHECKER("core.StackAddressEscape", StackAddrEscapeChecker, StackAddrEscapeChecker.cpp, "Check that addresses to stack memory do not escape the function", -1, false)
CHECKER("unix.StdCLibraryFunctions", StdCLibraryFunctionsChecker, StdLibraryFunctionsChecker.cpp, "Improve modeling of the C standard library functions", -1, false)
CHECKER("alpha.unix.Stream", StreamChecker, StreamChecker.cpp, "Check stream handling functions", -1, true)
CHECKER("debug.TaintTest", TaintTesterChecker, TaintTesterChecker.cpp, "Mark tainted symbols as such.", -1, false)
CHECKER("alpha.core.TestAfterDivZero", TestAfterDivZeroChecker, TestAfterDivZeroChecker.cpp, "Check for division by variable that is later compared against 0. Either the comparison is useless or there is division by zero.", -1, true)
CHECKER("debug.DumpTraversal", TraversalDumper, TraversalChecker.cpp, "Print branch conditions as they are traversed by the engine", -1, false)
CHECKER("apiModeling.TrustNonnull", TrustNonnullChecker, TrustNonnullChecker.cpp, "Trust that returns from framework methods annotated with _Nonnull are not null", -1, true)
CHECKER("security.insecureAPI.UncheckedReturn", UncheckedReturn, CheckSecuritySyntaxOnly.cpp, "Warn on uses of functions whose return values must be always checked", -1, false)
CHECKER("core.uninitialized.Branch", UndefBranchChecker, UndefBranchChecker.cpp, "Check for uninitialized values used as branch conditions", -1, false)
CHECKER("core.uninitialized.CapturedBlockVariable", UndefCapturedBlockVarChecker, UndefCapturedBlockVarChecker.cpp, "Check for blocks that capture uninitialized values", -1, false)
CHECKER("core.UndefinedBinaryOperatorResult", UndefResultChecker, UndefResultChecker.cpp, "Check for undefined results of binary operators", -1, false)
CHECKER("core.uninitialized.ArraySubscript", UndefinedArraySubscriptChecker, UndefinedArraySubscriptChecker.cpp, "Check for uninitialized values used as array subscripts", -1, false)
CHECKER("core.uninitialized.Assign", UndefinedAssignmentChecker, UndefinedAssignmentChecker.cpp, "Check for assigning uninitialized values", -1, false)
CHECKER("valist.Uninitialized", UninitializedChecker, ValistChecker.cpp, "Check for usages of uninitialized (or already released) va_lists.", -1, false)
CHECKER("alpha.cplusplus.UninitializedObject", UninitializedObjectChecker, UninitializedObjectChecker.cpp, "Reports uninitialized fields after object construction", -1, true)
CHECKER("unix.API", UnixAPIMisuseChecker, UnixAPIChecker.cpp, "Check calls to various UNIX/Posix functions", -1, false)
CHECKER("optin.portability.UnixAPI", UnixAPIPortabilityChecker, UnixAPIChecker.cpp, "Finds implementation-defined behavior in UNIX/Posix functions", -1, false)
CHECKER("alpha.deadcode.UnreachableCode", UnreachableCodeChecker, UnreachableCodeChecker.cpp, "Check unreachable code", -1, true)
CHECKER("valist.Unterminated", UnterminatedChecker, ValistChecker.cpp, "Check for va_lists which are not released by a va_end call.", -1, false)
CHECKER("core.VLASize", VLASizeChecker, VLASizeChecker.cpp, "Check for declarations of VLA of undefined or zero size", -1, false)
CHECKER("osx.cocoa.VariadicMethodTypes", VariadicMethodTypeChecker, BasicObjCFoundationChecks.cpp, "Check for passing non-Objective-C types to variadic collection initialization methods that expect only Objective-C types", -1, false)
CHECKER("unix.Vfork", VforkChecker, VforkChecker.cpp, "Check for proper usage of vfork", -1, false)
CHECKER("optin.cplusplus.VirtualCall", VirtualCallChecker, VirtualCallChecker.cpp, "Check virtual function calls during construction or destruction", -1, false)
CHECKER("security.insecureAPI.bcmp", bcmp, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'bcmp' function", -1, false)
CHECKER("security.insecureAPI.bcopy", bcopy, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'bcopy' function", -1, false)
CHECKER("security.insecureAPI.bzero", bzero, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'bzero' function", -1, false)
CHECKER("security.insecureAPI.getpw", getpw, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'getpw' function", -1, false)
CHECKER("security.insecureAPI.gets", gets, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'gets' function", -1, false)
CHECKER("security.insecureAPI.mkstemp", mkstemp, CheckSecuritySyntaxOnly.cpp, "Warn when 'mkstemp' is passed fewer than 6 X's in the format string", -1, false)
CHECKER("security.insecureAPI.mktemp", mktemp, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'mktemp' function", -1, false)
CHECKER("security.insecureAPI.rand", rand, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'rand', 'random', and related functions", -1, false)
CHECKER("security.insecureAPI.strcpy", strcpy, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'strcpy' and 'strcat' functions", -1, false)
CHECKER("security.insecureAPI.vfork", vfork, CheckSecuritySyntaxOnly.cpp, "Warn on uses of the 'vfork' function", -1, false)
#endif // GET_CHECKERS


#ifdef GET_MEMBER_ARRAYS
static const short SubPackageArray0[] = { 3, 17, 22, 32, 40, 24, 1, -1 };
static const short SubPackageArray1[] = { 2, -1 };
static const short CheckerArray2[] = { 28, -1 };
static const short SubPackageArray3[] = { 4, 6, 7, 8, 11, 10, 12, 13, 14, 5, 16, 9, 15, -1 };
static const short CheckerArray4[] = { 6, -1 };
static const short CheckerArray5[] = { 20, -1 };
static const short CheckerArray6[] = { 24, -1 };
static const short CheckerArray7[] = { 25, -1 };
static const short CheckerArray8[] = { 30, -1 };
static const short CheckerArray9[] = { 39, -1 };
static const short CheckerArray10[] = { 44, -1 };
static const short CheckerArray11[] = { 49, -1 };
static const short CheckerArray12[] = { 95, -1 };
static const short CheckerArray13[] = { 96, -1 };
static const short CheckerArray14[] = { 103, -1 };
static const short CheckerArray15[] = { 104, -1 };
static const short CheckerArray16[] = { 109, -1 };
static const short SubPackageArray17[] = { 18, 19, 20, 21, -1 };
static const short CheckerArray18[] = { 33, -1 };
static const short CheckerArray19[] = { 52, -1 };
static const short CheckerArray20[] = { 63, -1 };
static const short CheckerArray21[] = { 119, -1 };
static const short SubPackageArray22[] = { 23, -1 };
static const short CheckerArray23[] = { 122, -1 };
static const short SubPackageArray24[] = { 25, -1 };
static const short SubPackageArray25[] = { 30, 28, 29, 26, 27, -1 };
static const short CheckerArray26[] = { 35, -1 };
static const short CheckerArray27[] = { 36, -1 };
static const short CheckerArray28[] = { 51, -1 };
static const short CheckerArray29[] = { 62, -1 };
static const short SubPackageArray30[] = { 31, -1 };
static const short CheckerArray31[] = { 94, -1 };
static const short SubPackageArray32[] = { 38, 33, 34, 37, 35, 36, -1 };
static const short CheckerArray33[] = { 2, -1 };
static const short CheckerArray34[] = { 3, -1 };
static const short CheckerArray35[] = { 59, -1 };
static const short CheckerArray36[] = { 64, -1 };
static const short CheckerArray37[] = { 99, -1 };
static const short SubPackageArray38[] = { 39, -1 };
static const short CheckerArray39[] = { 48, -1 };
static const short SubPackageArray40[] = { 46, 42, 43, 45, 44, 41, -1 };
static const short CheckerArray41[] = { 5, -1 };
static const short CheckerArray42[] = { 26, -1 };
static const short CheckerArray43[] = { 97, -1 };
static const short CheckerArray44[] = { 102, -1 };
static const short CheckerArray45[] = { 107, -1 };
static const short SubPackageArray46[] = { 49, 47, 48, -1 };
static const short CheckerArray47[] = { 13, -1 };
static const short CheckerArray48[] = { 14, -1 };
static const short CheckerArray49[] = { 16, -1 };
static const short SubPackageArray50[] = { 52, 51, -1 };
static const short CheckerArray51[] = { 111, -1 };
static const short SubPackageArray52[] = { 53, -1 };
static const short CheckerArray53[] = { 47, -1 };
static const short SubPackageArray54[] = { 64, 67, 60, 55, 58, 63, 56, 62, 61, 57, 59, -1 };
static const short CheckerArray55[] = { 19, -1 };
static const short CheckerArray56[] = { 37, -1 };
static const short CheckerArray57[] = { 40, -1 };
static const short CheckerArray58[] = { 72, -1 };
static const short CheckerArray59[] = { 73, -1 };
static const short CheckerArray60[] = { 34, -1 };
static const short CheckerArray61[] = { 105, -1 };
static const short CheckerArray62[] = { 115, -1 };
static const short CheckerArray63[] = { 124, -1 };
static const short SubPackageArray64[] = { 66, 65, -1 };
static const short CheckerArray65[] = { 7, -1 };
static const short CheckerArray66[] = { 70, -1 };
static const short SubPackageArray67[] = { 68, 69, 70, 71, 72, -1 };
static const short CheckerArray68[] = { 116, -1 };
static const short CheckerArray69[] = { 117, -1 };
static const short CheckerArray70[] = { 113, -1 };
static const short CheckerArray71[] = { 114, -1 };
static const short CheckerArray72[] = { 100, -1 };
static const short SubPackageArray73[] = { 74, 75, 76, 77, -1 };
static const short CheckerArray74[] = { 50, -1 };
static const short CheckerArray75[] = { 67, -1 };
static const short CheckerArray76[] = { 68, -1 };
static const short CheckerArray77[] = { 18, -1 };
static const short SubPackageArray78[] = { 79, -1 };
static const short CheckerArray79[] = { 32, -1 };
static const short SubPackageArray80[] = { 81, 86, 87, 92, 83, 93, 84, 82, 88, 85, 90, 91, 89, 94, -1 };
static const short CheckerArray81[] = { 0, -1 };
static const short CheckerArray82[] = { 29, -1 };
static const short CheckerArray83[] = { 9, -1 };
static const short CheckerArray84[] = { 22, -1 };
static const short CheckerArray85[] = { 21, -1 };
static const short CheckerArray86[] = { 38, -1 };
static const short CheckerArray87[] = { 54, -1 };
static const short CheckerArray88[] = { 110, -1 };
static const short CheckerArray89[] = { 43, -1 };
static const short CheckerArray90[] = { 1, -1 };
static const short CheckerArray91[] = { 108, -1 };
static const short CheckerArray92[] = { 10, -1 };
static const short CheckerArray93[] = { 23, -1 };
static const short CheckerArray94[] = { 42, -1 };
static const short SubPackageArray95[] = { 96, -1 };
static const short CheckerArray96[] = { 53, -1 };
static const short SubPackageArray97[] = { 98, 99, 100, 101, 102, -1 };
static const short CheckerArray98[] = { 74, -1 };
static const short CheckerArray99[] = { 75, -1 };
static const short CheckerArray100[] = { 76, -1 };
static const short CheckerArray101[] = { 77, -1 };
static const short CheckerArray102[] = { 78, -1 };
static const short SubPackageArray103[] = { 116, 104, 113, 108, 106, -1 };
static const short SubPackageArray104[] = { 105, -1 };
static const short CheckerArray105[] = { 127, -1 };
static const short SubPackageArray106[] = { 107, -1 };
static const short CheckerArray107[] = { 55, -1 };
static const short SubPackageArray108[] = { 109, -1 };
static const short SubPackageArray109[] = { 110, -1 };
static const short SubPackageArray110[] = { 112, 111, -1 };
static const short CheckerArray111[] = { 41, -1 };
static const short CheckerArray112[] = { 71, -1 };
static const short SubPackageArray113[] = { 115, 114, -1 };
static const short CheckerArray114[] = { 46, -1 };
static const short CheckerArray115[] = { 93, -1 };
static const short SubPackageArray116[] = { 117, -1 };
static const short CheckerArray117[] = { 121, -1 };
static const short SubPackageArray118[] = { 123, 142, 120, 119, 122, 121, -1 };
static const short CheckerArray119[] = { 57, -1 };
static const short CheckerArray120[] = { 79, -1 };
static const short CheckerArray121[] = { 88, -1 };
static const short CheckerArray122[] = { 56, -1 };
static const short SubPackageArray123[] = { 137, 124, 133, 126, 141, 131, 128, 140, 138, 129, 134, 130, 132, 136, 135, 127, 139, 125, -1 };
static const short CheckerArray124[] = { 80, -1 };
static const short CheckerArray125[] = { 4, -1 };
static const short CheckerArray126[] = { 27, -1 };
static const short CheckerArray127[] = { 83, -1 };
static const short CheckerArray128[] = { 86, -1 };
static const short CheckerArray129[] = { 85, -1 };
static const short CheckerArray130[] = { 90, -1 };
static const short CheckerArray131[] = { 65, -1 };
static const short CheckerArray132[] = { 66, -1 };
static const short CheckerArray133[] = { 69, -1 };
static const short CheckerArray134[] = { 87, -1 };
static const short CheckerArray135[] = { 84, -1 };
static const short CheckerArray136[] = { 98, -1 };
static const short CheckerArray137[] = { 101, -1 };
static const short CheckerArray138[] = { 89, -1 };
static const short CheckerArray139[] = { 91, -1 };
static const short CheckerArray140[] = { 92, -1 };
static const short CheckerArray141[] = { 125, -1 };
static const short SubPackageArray142[] = { 146, 144, 145, 143, -1 };
static const short CheckerArray143[] = { 8, -1 };
static const short CheckerArray144[] = { 11, -1 };
static const short CheckerArray145[] = { 12, -1 };
static const short SubPackageArray146[] = { 148, 147, -1 };
static const short CheckerArray147[] = { 82, -1 };
static const short CheckerArray148[] = { 81, -1 };
static const short SubPackageArray149[] = { 151, 150, -1 };
static const short CheckerArray150[] = { 45, -1 };
static const short SubPackageArray151[] = { 153, 154, 155, 157, 156, 159, 158, 160, 161, 162, 152, -1 };
static const short CheckerArray152[] = { 112, -1 };
static const short CheckerArray153[] = { 128, -1 };
static const short CheckerArray154[] = { 129, -1 };
static const short CheckerArray155[] = { 130, -1 };
static const short CheckerArray156[] = { 131, -1 };
static const short CheckerArray157[] = { 132, -1 };
static const short CheckerArray158[] = { 133, -1 };
static const short CheckerArray159[] = { 134, -1 };
static const short CheckerArray160[] = { 135, -1 };
static const short CheckerArray161[] = { 136, -1 };
static const short CheckerArray162[] = { 137, -1 };
static const short SubPackageArray163[] = { 170, 164, 165, 166, 167, 169, 168, -1 };
static const short CheckerArray164[] = { 120, -1 };
static const short CheckerArray165[] = { 58, -1 };
static const short CheckerArray166[] = { 60, -1 };
static const short CheckerArray167[] = { 61, -1 };
static const short CheckerArray168[] = { 106, -1 };
static const short CheckerArray169[] = { 126, -1 };
static const short SubPackageArray170[] = { 172, 171, -1 };
static const short CheckerArray171[] = { 17, -1 };
static const short CheckerArray172[] = { 15, -1 };
static const short SubPackageArray173[] = { 175, 176, 174, -1 };
static const short CheckerArray174[] = { 31, -1 };
static const short CheckerArray175[] = { 118, -1 };
static const short CheckerArray176[] = { 123, -1 };
#endif // GET_MEMBER_ARRAYS


#ifdef GET_CHECKNAME_TABLE
  { "alpha",                                                          0, SubPackageArray0, false },
  { "alpha.clone",                                                    0, SubPackageArray1, true },
  { "alpha.clone.CloneChecker",                                       CheckerArray2, 0, false },
  { "alpha.core",                                                     0, SubPackageArray3, true },
  { "alpha.core.BoolAssignment",                                      CheckerArray4, 0, false },
  { "alpha.core.CallAndMessageUnInitRefArg",                          CheckerArray5, 0, false },
  { "alpha.core.CastSize",                                            CheckerArray6, 0, false },
  { "alpha.core.CastToStruct",                                        CheckerArray7, 0, false },
  { "alpha.core.Conversion",                                          CheckerArray8, 0, false },
  { "alpha.core.DynamicTypeChecker",                                  CheckerArray9, 0, false },
  { "alpha.core.FixedAddr",                                           CheckerArray10, 0, false },
  { "alpha.core.IdenticalExpr",                                       CheckerArray11, 0, false },
  { "alpha.core.PointerArithm",                                       CheckerArray12, 0, false },
  { "alpha.core.PointerSub",                                          CheckerArray13, 0, false },
  { "alpha.core.SizeofPtr",                                           CheckerArray14, 0, false },
  { "alpha.core.StackAddressAsyncEscape",                             CheckerArray15, 0, false },
  { "alpha.core.TestAfterDivZero",                                    CheckerArray16, 0, false },
  { "alpha.cplusplus",                                                0, SubPackageArray17, true },
  { "alpha.cplusplus.DeleteWithNonVirtualDtor",                       CheckerArray18, 0, false },
  { "alpha.cplusplus.IteratorRange",                                  CheckerArray19, 0, false },
  { "alpha.cplusplus.MisusedMovedObject",                             CheckerArray20, 0, false },
  { "alpha.cplusplus.UninitializedObject",                            CheckerArray21, 0, false },
  { "alpha.deadcode",                                                 0, SubPackageArray22, true },
  { "alpha.deadcode.UnreachableCode",                                 CheckerArray23, 0, false },
  { "alpha.osx",                                                      0, SubPackageArray24, true },
  { "alpha.osx.cocoa",                                                0, SubPackageArray25, true },
  { "alpha.osx.cocoa.DirectIvarAssignment",                           CheckerArray26, 0, false },
  { "alpha.osx.cocoa.DirectIvarAssignmentForAnnotatedFunctions",      CheckerArray27, 0, false },
  { "alpha.osx.cocoa.InstanceVariableInvalidation",                   CheckerArray28, 0, false },
  { "alpha.osx.cocoa.MissingInvalidationMethod",                      CheckerArray29, 0, false },
  { "alpha.osx.cocoa.localizability",                                 0, SubPackageArray30, true },
  { "alpha.osx.cocoa.localizability.PluralMisuseChecker",             CheckerArray31, 0, false },
  { "alpha.security",                                                 0, SubPackageArray32, true },
  { "alpha.security.ArrayBound",                                      CheckerArray33, 0, false },
  { "alpha.security.ArrayBoundV2",                                    CheckerArray34, 0, false },
  { "alpha.security.MallocOverflow",                                  CheckerArray35, 0, false },
  { "alpha.security.MmapWriteExec",                                   CheckerArray36, 0, false },
  { "alpha.security.ReturnPtrRange",                                  CheckerArray37, 0, false },
  { "alpha.security.taint",                                           0, SubPackageArray38, true },
  { "alpha.security.taint.TaintPropagation",                          CheckerArray39, 0, false },
  { "alpha.unix",                                                     0, SubPackageArray40, true },
  { "alpha.unix.BlockInCriticalSection",                              CheckerArray41, 0, false },
  { "alpha.unix.Chroot",                                              CheckerArray42, 0, false },
  { "alpha.unix.PthreadLock",                                         CheckerArray43, 0, false },
  { "alpha.unix.SimpleStream",                                        CheckerArray44, 0, false },
  { "alpha.unix.Stream",                                              CheckerArray45, 0, false },
  { "alpha.unix.cstring",                                             0, SubPackageArray46, true },
  { "alpha.unix.cstring.BufferOverlap",                               CheckerArray47, 0, false },
  { "alpha.unix.cstring.NotNullTerminated",                           CheckerArray48, 0, false },
  { "alpha.unix.cstring.OutOfBounds",                                 CheckerArray49, 0, false },
  { "apiModeling",                                                    0, SubPackageArray50, true },
  { "apiModeling.TrustNonnull",                                       CheckerArray51, 0, false },
  { "apiModeling.google",                                             0, SubPackageArray52, true },
  { "apiModeling.google.GTest",                                       CheckerArray53, 0, false },
  { "core",                                                           0, SubPackageArray54, false },
  { "core.CallAndMessage",                                            CheckerArray55, 0, false },
  { "core.DivideZero",                                                CheckerArray56, 0, false },
  { "core.DynamicTypePropagation",                                    CheckerArray57, 0, false },
  { "core.NonNullParamChecker",                                       CheckerArray58, 0, false },
  { "core.NonnilStringConstants",                                     CheckerArray59, 0, false },
  { "core.NullDereference",                                           CheckerArray60, 0, false },
  { "core.StackAddressEscape",                                        CheckerArray61, 0, false },
  { "core.UndefinedBinaryOperatorResult",                             CheckerArray62, 0, false },
  { "core.VLASize",                                                   CheckerArray63, 0, false },
  { "core.builtin",                                                   0, SubPackageArray64, false },
  { "core.builtin.BuiltinFunctions",                                  CheckerArray65, 0, false },
  { "core.builtin.NoReturnFunctions",                                 CheckerArray66, 0, false },
  { "core.uninitialized",                                             0, SubPackageArray67, false },
  { "core.uninitialized.ArraySubscript",                              CheckerArray68, 0, false },
  { "core.uninitialized.Assign",                                      CheckerArray69, 0, false },
  { "core.uninitialized.Branch",                                      CheckerArray70, 0, false },
  { "core.uninitialized.CapturedBlockVariable",                       CheckerArray71, 0, false },
  { "core.uninitialized.UndefReturn",                                 CheckerArray72, 0, false },
  { "cplusplus",                                                      0, SubPackageArray73, false },
  { "cplusplus.InnerPointer",                                         CheckerArray74, 0, false },
  { "cplusplus.NewDelete",                                            CheckerArray75, 0, false },
  { "cplusplus.NewDeleteLeaks",                                       CheckerArray76, 0, false },
  { "cplusplus.SelfAssignment",                                       CheckerArray77, 0, false },
  { "deadcode",                                                       0, SubPackageArray78, false },
  { "deadcode.DeadStores",                                            CheckerArray79, 0, false },
  { "debug",                                                          0, SubPackageArray80, false },
  { "debug.AnalysisOrder",                                            CheckerArray81, 0, false },
  { "debug.ConfigDumper",                                             CheckerArray82, 0, false },
  { "debug.DumpCFG",                                                  CheckerArray83, 0, false },
  { "debug.DumpCallGraph",                                            CheckerArray84, 0, false },
  { "debug.DumpCalls",                                                CheckerArray85, 0, false },
  { "debug.DumpDominators",                                           CheckerArray86, 0, false },
  { "debug.DumpLiveVars",                                             CheckerArray87, 0, false },
  { "debug.DumpTraversal",                                            CheckerArray88, 0, false },
  { "debug.ExprInspection",                                           CheckerArray89, 0, false },
  { "debug.Stats",                                                    CheckerArray90, 0, false },
  { "debug.TaintTest",                                                CheckerArray91, 0, false },
  { "debug.ViewCFG",                                                  CheckerArray92, 0, false },
  { "debug.ViewCallGraph",                                            CheckerArray93, 0, false },
  { "debug.ViewExplodedGraph",                                        CheckerArray94, 0, false },
  { "llvm",                                                           0, SubPackageArray95, false },
  { "llvm.Conventions",                                               CheckerArray96, 0, false },
  { "nullability",                                                    0, SubPackageArray97, false },
  { "nullability.NullPassedToNonnull",                                CheckerArray98, 0, false },
  { "nullability.NullReturnedFromNonnull",                            CheckerArray99, 0, false },
  { "nullability.NullableDereferenced",                               CheckerArray100, 0, false },
  { "nullability.NullablePassedToNonnull",                            CheckerArray101, 0, false },
  { "nullability.NullableReturnedFromNonnull",                        CheckerArray102, 0, false },
  { "optin",                                                          0, SubPackageArray103, false },
  { "optin.cplusplus",                                                0, SubPackageArray104, false },
  { "optin.cplusplus.VirtualCall",                                    CheckerArray105, 0, false },
  { "optin.mpi",                                                      0, SubPackageArray106, false },
  { "optin.mpi.MPI-Checker",                                          CheckerArray107, 0, false },
  { "optin.osx",                                                      0, SubPackageArray108, false },
  { "optin.osx.cocoa",                                                0, SubPackageArray109, false },
  { "optin.osx.cocoa.localizability",                                 0, SubPackageArray110, false },
  { "optin.osx.cocoa.localizability.EmptyLocalizationContextChecker", CheckerArray111, 0, false },
  { "optin.osx.cocoa.localizability.NonLocalizedStringChecker",       CheckerArray112, 0, false },
  { "optin.performance",                                              0, SubPackageArray113, false },
  { "optin.performance.GCDAntipattern",                               CheckerArray114, 0, false },
  { "optin.performance.Padding",                                      CheckerArray115, 0, false },
  { "optin.portability",                                              0, SubPackageArray116, false },
  { "optin.portability.UnixAPI",                                      CheckerArray117, 0, false },
  { "osx",                                                            0, SubPackageArray118, false },
  { "osx.API",                                                        CheckerArray119, 0, false },
  { "osx.NumberObjectConversion",                                     CheckerArray120, 0, false },
  { "osx.ObjCProperty",                                               CheckerArray121, 0, false },
  { "osx.SecKeychainAPI",                                             CheckerArray122, 0, false },
  { "osx.cocoa",                                                      0, SubPackageArray123, false },
  { "osx.cocoa.AtSync",                                               CheckerArray124, 0, false },
  { "osx.cocoa.AutoreleaseWrite",                                     CheckerArray125, 0, false },
  { "osx.cocoa.ClassRelease",                                         CheckerArray126, 0, false },
  { "osx.cocoa.Dealloc",                                              CheckerArray127, 0, false },
  { "osx.cocoa.IncompatibleMethodTypes",                              CheckerArray128, 0, false },
  { "osx.cocoa.Loops",                                                CheckerArray129, 0, false },
  { "osx.cocoa.MissingSuperCall",                                     CheckerArray130, 0, false },
  { "osx.cocoa.NSAutoreleasePool",                                    CheckerArray131, 0, false },
  { "osx.cocoa.NSError",                                              CheckerArray132, 0, false },
  { "osx.cocoa.NilArg",                                               CheckerArray133, 0, false },
  { "osx.cocoa.NonNilReturnValue",                                    CheckerArray134, 0, false },
  { "osx.cocoa.ObjCGenerics",                                         CheckerArray135, 0, false },
  { "osx.cocoa.RetainCount",                                          CheckerArray136, 0, false },
  { "osx.cocoa.RunLoopAutoreleaseLeak",                               CheckerArray137, 0, false },
  { "osx.cocoa.SelfInit",                                             CheckerArray138, 0, false },
  { "osx.cocoa.SuperDealloc",                                         CheckerArray139, 0, false },
  { "osx.cocoa.UnusedIvars",                                          CheckerArray140, 0, false },
  { "osx.cocoa.VariadicMethodTypes",                                  CheckerArray141, 0, false },
  { "osx.coreFoundation",                                             0, SubPackageArray142, false },
  { "osx.coreFoundation.CFError",                                     CheckerArray143, 0, false },
  { "osx.coreFoundation.CFNumber",                                    CheckerArray144, 0, false },
  { "osx.coreFoundation.CFRetainRelease",                             CheckerArray145, 0, false },
  { "osx.coreFoundation.containers",                                  0, SubPackageArray146, false },
  { "osx.coreFoundation.containers.OutOfBounds",                      CheckerArray147, 0, false },
  { "osx.coreFoundation.containers.PointerSizedValues",               CheckerArray148, 0, false },
  { "security",                                                       0, SubPackageArray149, false },
  { "security.FloatLoopCounter",                                      CheckerArray150, 0, false },
  { "security.insecureAPI",                                           0, SubPackageArray151, false },
  { "security.insecureAPI.UncheckedReturn",                           CheckerArray152, 0, false },
  { "security.insecureAPI.bcmp",                                      CheckerArray153, 0, false },
  { "security.insecureAPI.bcopy",                                     CheckerArray154, 0, false },
  { "security.insecureAPI.bzero",                                     CheckerArray155, 0, false },
  { "security.insecureAPI.getpw",                                     CheckerArray156, 0, false },
  { "security.insecureAPI.gets",                                      CheckerArray157, 0, false },
  { "security.insecureAPI.mkstemp",                                   CheckerArray158, 0, false },
  { "security.insecureAPI.mktemp",                                    CheckerArray159, 0, false },
  { "security.insecureAPI.rand",                                      CheckerArray160, 0, false },
  { "security.insecureAPI.strcpy",                                    CheckerArray161, 0, false },
  { "security.insecureAPI.vfork",                                     CheckerArray162, 0, false },
  { "unix",                                                           0, SubPackageArray163, false },
  { "unix.API",                                                       CheckerArray164, 0, false },
  { "unix.Malloc",                                                    CheckerArray165, 0, false },
  { "unix.MallocSizeof",                                              CheckerArray166, 0, false },
  { "unix.MismatchedDeallocator",                                     CheckerArray167, 0, false },
  { "unix.StdCLibraryFunctions",                                      CheckerArray168, 0, false },
  { "unix.Vfork",                                                     CheckerArray169, 0, false },
  { "unix.cstring",                                                   0, SubPackageArray170, true },
  { "unix.cstring.BadSizeArg",                                        CheckerArray171, 0, false },
  { "unix.cstring.NullArg",                                           CheckerArray172, 0, false },
  { "valist",                                                         0, SubPackageArray173, false },
  { "valist.CopyToSelf",                                              CheckerArray174, 0, false },
  { "valist.Uninitialized",                                           CheckerArray175, 0, false },
  { "valist.Unterminated",                                            CheckerArray176, 0, false },
#endif // GET_CHECKNAME_TABLE

