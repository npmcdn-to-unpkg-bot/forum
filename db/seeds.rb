# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
topics = [
    {
        name:'Introduce Yourself'
    },
    {
        name:'UFO and Alien Discussions'
    },
    {
        name:'UFO and Alien Experiences or Dreams'
    },
    {
        name:'UFOs and Aliens in Religion'
    },
    {
        name:'Ancient Civilizations, Archaeology, and Anthropology'
    },
    {
        name:'Paranormal, Consciousness, and the Supernatural'
    },
    {
        name:'Cryptozoology, Botany, and the Animal Kingdom'
    },
    {
        name:'Conspiracy Theories'
    },
    {
        name:'Armageddon and the End Times'
    },
    {
        name:'Computers, Astronomy, Science, and Technology'
    }
]

Topic.create topics
