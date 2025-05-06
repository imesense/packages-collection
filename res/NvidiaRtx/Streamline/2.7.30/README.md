# Streamline (SL) - Version 2.7.30

Streamline is an open-sourced cross-IHV solution that simplifies integration of the latest NVIDIA and other independent hardware vendors’ super resolution technologies into applications and games. This framework allows developers to easily implement one single integration and enable multiple super-resolution technologies and other graphics effects supported by the hardware vendor.

This repo contains the SDK for integrating Streamline into your application.

For a high level overview, see the [NVIDIA Developer Streamline page](https://developer.nvidia.com/rtx/streamline)

As of SL 2.0.0, it is now possible to recompile all of SL from source, with the exception of the DLSS-G plugin.  The DLSS-G plugin is provided as prebuilt DLLs only.  We also provide prebuilt DLLs (signed) for all other plugins that have source.  Most application developers will never need to rebuild SL themselves, especially for shipping; all of the pieces needed to develop, debug and ship an application that integrates SL and its features are provided in the pre-existing directories `bin/`, `include/`, and `lib/`.  Compiling from source is purely optional and likely of interest to a subset of SL application developers. For developers wishing to build SL from source, see the following sections.
