package sample.consumer;

import sample.api.ServiceApi;

import gw.lang.reflect.ReflectUtil;
import gw.lang.Gosu;

import java.io.File;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

public class ServiceConsumer {
    private static final String GOSU_LIB = "c:\\DATA\\PROJECTS\\GOSU\\java-gosu-interop\\dist\\jginterop-provider-0.1.jar";
    
    public ServiceConsumer() {
    }

    public String consume() {
        List<File> gosuPath = new ArrayList<File>();
        // path to libraries
        gosuPath.add(new File(GOSU_LIB));
        Gosu.init(gosuPath);
        ServiceApi service = (ServiceApi) ReflectUtil.construct("sample.provider.ServiceProvider");
        return service.execute();
    }

    public static void main(String[] args) throws URISyntaxException {
        ServiceConsumer consumer = new ServiceConsumer();
        System.out.println(consumer.consume());
    }
}
