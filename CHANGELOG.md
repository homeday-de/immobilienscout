# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.0.8] - 2020-07-16
* Added retrieve_all endpoint to attachments to retrieve all attachments of a property
* Added destroy endpoint to attachments to destroy an attachment of a property

## [0.0.7] - 2020-03-30
* Improve error handling. Catching a `InvalidRequest` error still works, but now
  there are additional errors for a more fine-grained error-handling. Namely
  `ResourceNotFound`, `CommonResourceNotFound` and `ResourceValidation`.
* Add `rubocop`, `rubocop-rspec` and `rubocop-performance`
* Build with Ruby `2.6.5` on Travis

## [0.0.6] - 2020-02-18
Adding update endpoint to update a property

## [0.0.5] - 2020-02-06
Adding show endpoint to retrieve a single property

## [0.0.4] - 2019-10-17
Adding endpoint to update order of attachments for a specific property

## [0.0.3] - 2019-08-15
Update the response accord to the Immobilienscout changes in the `JSON` structure

## [0.0.2] - 2019-06-17
Fixing bugs:
* Require `timecop` in `immoscout.rb`
* Require `byebug` in `immoscout.rb`

## [0.0.1] - 2019-06-13
Releasing the gem with five endpoints:
* Create Property
* Publish Property
* Delete Property
* Add Attachment
* Generate ScoutReport
