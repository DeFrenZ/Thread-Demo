#if ENABLE_SAMPLES
extension DataUIStore {
	static var sample: DataUIStore {
		.init(.sample)
	}

	static var sampleLoaded: DataUIStore {
		.init(.sampleLoaded)
	}

	static var sampleLoading: DataUIStore {
		.init(.sampleLoading)
	}
}
#endif
