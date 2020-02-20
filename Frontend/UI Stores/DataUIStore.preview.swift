#if ENABLE_SAMPLES
extension DataUIStore {
	public static var sample: DataUIStore {
		.init(.sample)
	}

	public static var sampleLoaded: DataUIStore {
		.init(.sampleLoaded)
	}

	public static var sampleLoading: DataUIStore {
		.init(.sampleLoading)
	}
}
#endif
