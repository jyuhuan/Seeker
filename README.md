## Seeker

Seeker is a Finder extension for programmers. 

<img src="https://cloud.githubusercontent.com/assets/4944003/20614218/eeed189a-b299-11e6-8ad6-65a49c03b58a.png" width=540px />


### Current Rules

> ⚠️ This project is at a very early stage. Nothing is flexible. All rules are hardcoded. 

#### Opening Methods
- If `.idea/` exists, then
	- Open with IntelliJ IDEA
- If `.git/` exists
	- Open on GitHub (if remote is on GitHub)
	- Open on BitBucket (if remote is on BitBucket)

#### Operations
- If `build.sbt` exists, then
	- SBT
		- Publish Signed
		- Assembly
		- Compile
		- Run
		- Clean
- If `.git/` exists, then
	- GIT
		- Commit
		- Push
- If `Package.swift` exists, then
	- SwiftPM
		- Build
		- Update
		- Create Xcode Project
- If `package.json` exists, then
	- NPM
		- Install
		
### RoadMap
- Add operations to files. Currently operations are triggered only on folders. However, operations on individual files are also important. E.g., within a Git managed folder, each file should have an operation called *Add to Git*.
- Allow users to define their own rules of opening methods and operations through an XML/Json/YAML/etc. configuration file.