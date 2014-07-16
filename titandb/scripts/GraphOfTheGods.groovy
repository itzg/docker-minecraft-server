import com.thinkaurelius.titan.core.TitanFactory
import com.thinkaurelius.titan.example.GraphOfTheGodsFactory

def g = TitanFactory.open('conf/titan.properties')
GraphOfTheGodsFactory.load(g)

g.shutdown()
