import com.thinkaurelius.titan.core.TitanFactory
import com.thinkaurelius.titan.core.TitanGraph
import com.thinkaurelius.titan.graphdb.configuration.GraphDatabaseConfiguration
import org.apache.commons.configuration.BaseConfiguration
import org.apache.commons.configuration.Configuration

// Setup a blank one

TitanGraph g = TitanFactory.open('conf/titan.properties')
g.shutdown()


