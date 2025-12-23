defmodule Alike.TestSentences do
  @moduledoc """
  Comprehensive test sentences for semantic similarity testing.
  """

  @doc """
  Sentence pairs that should be considered ALIKE (paraphrases/entailments).
  """
  def similar_pairs do
    [
      # Animals
      {"The cat is sleeping on the couch", "A feline is napping on the sofa"},
      {"The dog ran across the yard", "A canine sprinted through the garden"},
      {"Birds are flying south for winter", "Avian creatures migrate southward in cold months"},
      {"The horse galloped through the field", "The stallion ran swiftly across the meadow"},
      {"Fish swim in the ocean", "Marine creatures move through seawater"},
      {"The elephant is the largest land animal",
       "Elephants are the biggest terrestrial creatures"},
      {"Wolves hunt in packs", "Wolf groups pursue prey together"},
      {"The butterfly landed on the flower", "A lepidopteran rested on the blossom"},
      {"Bees make honey", "Honey is produced by bees"},
      {"The snake slithered through the grass", "A serpent moved through the vegetation"},

      # Weather
      {"It's raining outside", "Water is falling from the sky"},
      {"The sun is shining brightly", "Sunlight illuminates the area intensely"},
      {"Snow is falling", "Frozen precipitation descends from clouds"},
      {"The wind is blowing hard", "Strong gusts are moving through the air"},
      {"It's a cloudy day", "The sky is overcast today"},
      {"Thunder rumbled in the distance", "A thunderous sound echoed far away"},
      {"The temperature is very high", "It's extremely hot"},
      {"Frost covered the ground", "Ice crystals formed on the surface"},
      {"The fog is thick this morning", "Dense mist blankets the area at dawn"},
      {"A rainbow appeared after the storm", "Colorful arc formed following the rainfall"},

      # Food & Cooking
      {"I'm cooking dinner", "I'm preparing the evening meal"},
      {"The soup is delicious", "This broth tastes wonderful"},
      {"She baked a cake", "She made a cake in the oven"},
      {"The coffee is hot", "This beverage has a high temperature"},
      {"He's eating breakfast", "He's having his morning meal"},
      {"The fruit is ripe", "The produce is ready to eat"},
      {"Water is boiling on the stove", "H2O is reaching 100 degrees on the cooktop"},
      {"The bread is fresh", "This loaf was recently baked"},
      {"She added salt to the dish", "She seasoned the food with sodium chloride"},
      {"The restaurant is crowded", "The eatery is full of people"},

      # Technology
      {"The computer is running slowly", "The PC has poor performance"},
      {"She sent an email", "She transmitted an electronic message"},
      {"The phone is charging", "The mobile device is gaining battery power"},
      {"He downloaded the file", "He transferred the data to his device"},
      {"The website is loading", "The web page is being retrieved"},
      {"The printer is out of paper", "The printing device needs more sheets"},
      {"The software needs an update", "The program requires a newer version"},
      {"She's browsing the internet", "She's surfing the web"},
      {"The battery is dead", "The power cell is depleted"},
      {"He connected to WiFi", "He established a wireless network connection"},

      # Emotions & States
      {"She is happy", "She feels joyful"},
      {"He's feeling tired", "He's experiencing fatigue"},
      {"They are excited", "They feel enthusiastic"},
      {"I'm hungry", "I need food"},
      {"She looks worried", "She appears anxious"},
      {"He seems confused", "He appears bewildered"},
      {"They are celebrating", "They are having a party"},
      {"She's laughing", "She's expressing amusement"},
      {"He feels lonely", "He experiences solitude"},

      # Actions & Activities
      {"She's reading a book", "She's perusing a novel"},
      {"He's playing guitar", "He's strumming a stringed instrument"},
      {"They're watching a movie", "They're viewing a film"},
      {"She's painting a picture", "She's creating artwork on canvas"},
      {"He's running a marathon", "He's participating in a long-distance race"},
      {"They're building a house", "They're constructing a dwelling"},
      {"She's teaching a class", "She's instructing students"},
      {"He's driving to work", "He's commuting by car to his job"},
      {"They're planning a trip", "They're organizing a journey"},

      # Nature & Environment
      {"The river flows to the sea", "The waterway leads to the ocean"},
      {"Mountains are covered in snow", "Peaks are blanketed with frozen precipitation"},
      {"The forest is dense", "The woodland is thick with trees"},
      {"Flowers bloom in spring", "Blossoms appear during springtime"},
      {"The desert is hot and dry", "Arid regions have high temperatures and low moisture"},
      {"Leaves fall in autumn", "Foliage drops during fall season"},
      {"The ocean is vast", "The sea is immense"},
      {"Stars shine at night", "Celestial bodies illuminate the darkness"},
      {"The volcano erupted", "The mountain expelled lava"},
      {"Glaciers are melting", "Ice masses are dissolving"},

      # Work & Business
      {"She got a promotion", "She advanced in her career"},
      {"The meeting was cancelled", "The conference was called off"},
      {"He quit his job", "He resigned from his position"},
      {"The company is hiring", "The business is recruiting employees"},
      {"Sales increased this quarter", "Revenue grew in this period"},
      {"The deadline is tomorrow", "The due date is the next day"},
      {"She's working overtime", "She's putting in extra hours"},
      {"The project is complete", "The work is finished"},
      {"He received a bonus", "He got extra compensation"},
      {"The office is closed", "The workplace is not open"},

      # Health & Body
      {"I have a headache", "My head hurts"},
      {"She's feeling sick", "She's not feeling well"},
      {"He broke his arm", "He fractured his upper limb"},
      {"The doctor prescribed medicine", "The physician recommended medication"},
      {"She's recovering from surgery", "She's healing after the operation"},
      {"The patient is improving", "The sick person is getting better"},
      {"She's exercising regularly", "She works out consistently"},
      {"He lost weight", "He became lighter"},
      {"The wound is healing", "The injury is getting better"},

      # Education
      {"The student passed the exam", "The pupil succeeded on the test"},
      {"She's studying for finals", "She's preparing for end-of-term exams"},
      {"He graduated from college", "He completed his university degree"},
      {"The teacher explained the concept", "The instructor clarified the idea"},
      {"She's learning a new language", "She's acquiring foreign language skills"},
      {"The homework is due Monday", "The assignment must be submitted on Monday"},
      {"He's attending a lecture", "He's listening to a professor speak"},
      {"The school is closed today", "The educational institution is not open"},
      {"She earned good grades", "She achieved high marks"},
      {"The library is quiet", "The book repository is silent"},

      # Travel & Transportation
      {"The plane took off", "The aircraft departed"},
      {"She's driving to the airport", "She's heading to the flight terminal by car"},
      {"The train arrived on time", "The railway vehicle came punctually"},
      {"He missed his flight", "He didn't catch his plane"},
      {"Traffic is heavy", "The roads are congested"},
      {"She booked a hotel room", "She reserved accommodation"},
      {"The ship sailed across the ocean", "The vessel traveled over the sea"},
      {"He's waiting at the bus stop", "He's standing at the transit station"},
      {"The car broke down", "The vehicle stopped working"},
      {"She packed her suitcase", "She filled her luggage"},

      # Home & Living
      {"The house is big", "The residence is large"},
      {"She cleaned the kitchen", "She tidied up the cooking area"},
      {"He's mowing the lawn", "He's cutting the grass"},
      {"She's decorating the room", "She's adorning the space"},
      {"The roof is leaking", "Water is coming through the top of the house"},
      {"He fixed the broken window", "He repaired the damaged glass pane"},
      {"The garden needs watering", "The plants require hydration"},
      {"She's doing laundry", "She's washing clothes"},
    ]
  end

  @doc """
  Sentence pairs that are CONTRADICTIONS (opposite meanings).
  """
  def contradiction_pairs do
    [
      # Direct opposites
      {"The sky is blue", "The sky is red"},
      {"I love pizza", "I hate pizza"},
      {"She is happy", "She is sad"},
      {"The door is open", "The door is closed"},
      {"It is raining", "It is sunny and dry"},
      {"He is tall", "He is short"},
      {"The water is hot", "The water is cold"},
      {"She passed the test", "She failed the test"},
      {"The store is open", "The store is closed"},
      {"He arrived early", "He arrived late"},

      # Temperature contradictions
      {"It's freezing outside", "It's boiling hot outside"},
      {"The coffee is scalding", "The coffee is ice cold"},
      {"Summer is the hottest season", "Summer is the coldest season"},
      {"The ice cream melted", "The ice cream stayed frozen solid"},
      {"The fire is burning", "The fire is completely extinguished"},

      # Size contradictions
      {"The elephant is huge", "The elephant is tiny"},
      {"The room is spacious", "The room is cramped"},
      {"The building is tall", "The building is short"},
      {"The portion was enormous", "The portion was minuscule"},
      {"The crowd was massive", "The crowd was nonexistent"},

      # Speed contradictions
      {"The car is moving fast", "The car is completely stationary"},
      {"He ran quickly", "He walked slowly"},
      {"The train arrived early", "The train arrived very late"},
      {"She finished quickly", "She took forever to finish"},
      {"Time flies", "Time drags on slowly"},

      # Quantity contradictions
      {"The glass is full", "The glass is empty"},
      {"There are many people here", "There is nobody here"},
      {"She has a lot of money", "She has no money at all"},
      {"The tank is completely full", "The tank is bone dry"},
      {"Everything is included", "Nothing is included"},

      # State contradictions
      {"He is alive", "He is dead"},
      {"She is awake", "She is asleep"},
      {"The light is on", "The light is off"},
      {"The machine is working", "The machine is broken"},
      {"The food is fresh", "The food is rotten"},

      # Direction contradictions
      {"Go north", "Go south"},
      {"Turn left", "Turn right"},
      {"Move forward", "Move backward"},
      {"The sun rises in the east", "The sun rises in the west"},
      {"Water flows downhill", "Water flows uphill"},

      # Quality contradictions
      {"The movie was excellent", "The movie was terrible"},
      {"The food tastes delicious", "The food tastes disgusting"},
      {"The service was outstanding", "The service was awful"},
      {"This is a masterpiece", "This is garbage"},
      {"The weather is beautiful", "The weather is horrible"},

      # Truth contradictions
      {"He told the truth", "He told a lie"},
      {"She was honest", "She was deceptive"},
      {"The statement is accurate", "The statement is false"},
      {"This is a fact", "This is fiction"},
      {"The claim is verified", "The claim is debunked"},

      # Possession contradictions
      {"I have the keys", "I don't have the keys"},
      {"She owns a car", "She doesn't own any vehicle"},
      {"They have children", "They have no children"},
      {"He brought his laptop", "He forgot his laptop"},
      {"We have enough supplies", "We have no supplies left"},

      # Action contradictions
      {"She accepted the offer", "She rejected the offer"},
      {"He won the game", "He lost the game"},
      {"They agreed to the terms", "They disagreed with the terms"},
      {"I remembered your birthday", "I forgot your birthday"},
      {"She started the project", "She never began the project"},

      # Existence contradictions
      {"The file exists", "The file doesn't exist"},
      {"There is a solution", "There is no solution"},
      {"Problems remain", "All problems are solved"},
      {"Evidence was found", "No evidence was found"},
      {"The species is thriving", "The species is extinct"},

      # Certainty contradictions
      {"I am sure about this", "I am completely uncertain about this"},
      {"This will definitely happen", "This will never happen"},
      {"It's absolutely possible", "It's completely impossible"},
      {"The outcome is predictable", "The outcome is totally random"},

      # Emotion contradictions
      {"She loves him", "She hates him"},
      {"He's excited about the trip", "He dreads the trip"},
      {"They're optimistic", "They're pessimistic"},
      {"I enjoy this activity", "I despise this activity"},
      {"She was pleased with the result", "She was furious with the result"},

      # Time contradictions
      {"The event is starting soon", "The event was cancelled"},
      {"He always exercises", "He never exercises"},
      {"She frequently visits", "She never visits"},
      {"This happens every day", "This has never happened"},
      {"The meeting is today", "There is no meeting scheduled"},

      # Location contradictions
      {"She is at home", "She is at the office"},
      {"He lives in New York", "He has never been to New York"},
      {"They stayed inside", "They went outside"},

      # Permission contradictions
      {"Access is granted", "Access is denied"},
      {"Smoking is allowed here", "Smoking is strictly prohibited here"},
      {"Entry is free", "There is an admission fee"},
      {"Parking is permitted", "Parking is forbidden"},
      {"Photography is encouraged", "Photography is banned"},

      # Comparison contradictions
      {"This is better than that", "This is worse than that"},
      {"She's older than her sister", "She's younger than her sister"},
      {"The new version is improved", "The new version is degraded"},
      {"Sales are up", "Sales are down"},
      {"The situation improved", "The situation deteriorated"},

      # Ability contradictions
      {"He can swim", "He cannot swim at all"},
      {"She speaks French fluently", "She doesn't know any French"},
      {"They're capable of finishing", "They're incapable of finishing"},
      {"I understand the concept", "I don't understand the concept"},
      {"The machine can process this", "The machine cannot handle this"},

      # Agreement contradictions
      {"We reached a consensus", "We couldn't agree on anything"},
      {"Everyone supported the plan", "Everyone opposed the plan"},
      {"The vote was unanimous", "The vote was split"},
      {"They signed the contract", "They refused to sign"},
      {"Both parties are satisfied", "Both parties are dissatisfied"}
    ]
  end

  @doc """
  Sentence pairs that are UNRELATED (different topics entirely).
  """
  def unrelated_pairs do
    [
      # Random unrelated topics
      {"The weather is nice today", "I enjoy reading books"},
      {"She bought a new car", "The Eiffel Tower is in Paris"},
      {"Mathematics is difficult", "Dogs are loyal pets"},
      {"The concert starts at 8pm", "Bananas are yellow"},
      {"He studies chemistry", "Soccer is a popular sport"},
      {"The ocean is salty", "She plays the piano"},
      {"Mount Everest is tall", "Coffee contains caffeine"},
      {"The movie was long", "Butterflies have colorful wings"},
      {"I need to buy groceries", "Shakespeare wrote plays"},
      {"The phone is ringing", "Elephants have trunks"},

      # Science vs Daily life
      {"Photosynthesis produces oxygen", "I need to do laundry"},
      {"Atoms contain electrons", "The restaurant closes at 10"},
      {"DNA carries genetic information", "My car needs an oil change"},
      {"Gravity pulls objects down", "She's planning a birthday party"},
      {"The speed of light is constant", "I'm making spaghetti for dinner"},

      # History vs Nature
      {"World War II ended in 1945", "Roses bloom in spring"},
      {"The Roman Empire fell", "Dolphins are intelligent mammals"},
      {"The pyramids were built in Egypt", "Oak trees lose their leaves"},
      {"The Industrial Revolution changed society", "Salmon swim upstream"},
      {"Columbus sailed in 1492", "Cacti grow in deserts"},

      # Technology vs Food
      {"Computers use binary code", "Pizza originated in Italy"},
      {"The internet connects billions", "Apples are nutritious"},
      {"Smartphones have cameras", "Sushi is a Japanese dish"},
      {"Artificial intelligence is advancing", "Chocolate contains sugar"},
      {"Quantum computing is complex", "Bread needs yeast to rise"},

      # Geography vs Entertainment
      {"The Amazon is the longest river", "The Beatles were from Liverpool"},
      {"Antarctica is covered in ice", "Star Wars has many sequels"},
      {"The Sahara is a desert", "Video games are interactive"},
      {"Japan is an island nation", "Jazz originated in New Orleans"},
      {"The Grand Canyon is deep", "Shakespeare wrote Romeo and Juliet"},

      # Sports vs Science
      {"Basketball requires teamwork", "Water boils at 100 degrees Celsius"},
      {"Tennis uses rackets", "The Earth orbits the Sun"},
      {"Swimming is good exercise", "Hydrogen is the lightest element"},
      {"Golf originated in Scotland", "Volcanoes can be dormant"},
      {"The Olympics happen every four years", "Light travels in waves"},

      # Art vs Mathematics
      {"Picasso was a famous painter", "Pi equals approximately 3.14159"},
      {"The Mona Lisa hangs in the Louvre", "Triangles have three sides"},
      {"Sculptures can be made of marble", "Algebra uses variables"},
      {"Photography captures moments", "The Pythagorean theorem involves squares"},
      {"Music consists of notes", "Calculus deals with derivatives"},

      # Animals vs Business
      {"Lions are apex predators", "Stocks can be volatile"},
      {"Penguins live in cold climates", "Marketing increases brand awareness"},
      {"Whales are the largest mammals", "Entrepreneurs take risks"},
      {"Spiders spin webs", "Quarterly reports show earnings"},
      {"Bats navigate using echolocation", "Mergers combine companies"},

      # Weather vs History
      {"Hurricanes form over warm water", "The Renaissance began in Italy"},
      {"Tornadoes are destructive", "The French Revolution started in 1789"},
      {"Fog reduces visibility", "Ancient Greece had philosophers"},
      {"Droughts cause water shortages", "The printing press was invented"},
      {"Blizzards bring heavy snow", "The Cold War lasted decades"},

      # Medicine vs Astronomy
      {"Vaccines prevent diseases", "Mars is called the Red Planet"},
      {"Antibiotics fight bacteria", "Black holes have strong gravity"},
      {"Surgery requires precision", "The Milky Way is our galaxy"},
      {"Blood carries oxygen", "Satellites orbit Earth"},
      {"Vitamins support health", "Nebulae are clouds of gas"}
    ]
  end

  @doc """
  Additional edge cases and tricky pairs.
  """
  def edge_cases do
    [
      # Negation handling
      {"He is not happy", "He is sad"},
      {"She didn't fail", "She succeeded"},
      {"It's not cold", "It's warm"},
      {"They weren't late", "They arrived on time"},
      {"I don't dislike it", "I like it"},

      # Similar structure, different meaning
      {"The bank by the river is muddy", "The bank charges high fees"},
      {"He saw her duck", "The duck swam in the pond"},
      {"Time flies like an arrow", "Fruit flies like a banana"},
      {"The bass was heavy", "The bass note was deep"},
      {"She can't bear the weight", "The bear ate the fish"},

      # Subtle differences
      {"He's in the hospital", "He works at the hospital"},
      {"She made a cake", "She bought a cake"},
      {"They went to Paris", "They're from Paris"},
      {"I read the book", "I wrote the book"},
      {"He fixed the car", "He broke the car"},

      # Temporal differences
      {"She will arrive tomorrow", "She arrived yesterday"},
      {"They used to live here", "They live here now"},
      {"The event was postponed", "The event happened on schedule"},
      {"It's going to rain", "It just stopped raining"},
      {"He's about to leave", "He already left"},

      # Quantifier differences
      {"All students passed", "Some students passed"},
      {"Nobody showed up", "Everybody showed up"},
      {"Few people know this", "Many people know this"},
      {"She always helps", "She sometimes helps"},
      {"Everything is ready", "Nothing is ready"}
    ]
  end
end
