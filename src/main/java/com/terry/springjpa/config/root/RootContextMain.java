package com.terry.springjpa.config.root;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.Import;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.terry.springjpa.common.converter.BoardTypeToBoardTypeVOConverter;
import com.terry.springjpa.common.converter.BoardTypeVOToBoardTypeConverter;
import com.terry.springjpa.common.converter.MemberToMemberVOConverter;
import com.terry.springjpa.common.converter.MemberVOToMemberConverter;
import com.terry.springjpa.entity.BoardType;
import com.terry.springjpa.entity.Member;

@Configuration
@Import({LocalConfig.class, ProductionConfig.class, DevConfig.class, JpaConfig.class, MybatisConfig.class, TransactionConfig.class})
@ComponentScan(
		basePackages="com.terry.springjpa",  
		useDefaultFilters = false,
		includeFilters={
				@ComponentScan.Filter(type=FilterType.ANNOTATION, value=Service.class),
				@ComponentScan.Filter(type=FilterType.ANNOTATION, value=Repository.class)
		}
)
@EnableAspectJAutoProxy(proxyTargetClass=true)
public class RootContextMain {

	/**
	 * @Value 어노테이션에 ${}를 이용해서 값을 가져오도록 하기 위해 PropertySourcesPlaceholderConfigurer bean을 선언한다.
	 * 이 Bean 선언의 경우 두가지 주의점이 있다
	 * 1. 반드시 static 으로 선언할것(@Configuration 에서조차도 @Value 어노테이션을 이용해서 ${}를 사용하는 것이기 때문에 가장 먼저 로드가 되어야 하기 때문이다)
	 * 2. Root Context에 선언되어 있다 하더라도 Servlet Context 에서도 따로 선언해주어야 한다
	 * Root Context에 선언된 것은 Root Context의 @Configuration에서만 영향력을 갖지 Servlet Context가 이것을 끌어와서 사용하는 개념이 아니기 때문이다
	 * @return
	 */
	@Bean
	public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
		return new PropertySourcesPlaceholderConfigurer();
	}
	
	/**
	 * BoardType Entity 클래스 객체를 BoardTypeVO 클래스 객체로 변환하는 Converter 클래스 객체를 bean으로 등록한다
	 * @return
	 */
	@Bean
	public BoardTypeToBoardTypeVOConverter boardTypeToBoardTypeVOConverter(){
		return new BoardTypeToBoardTypeVOConverter();
		
	}
	
	/**
	 * BoardTypeVO 클래스 객체를 BoardType 엔티티 클래스 객체로 변환하는 Converter 클래스 객체를 bean으로 등록한다
	 * @param repository BoardType 엔티티 관련 Spring Data JpaRepository 인터페이스를 구현한 bean 객체
	 * @return
	 */
	@Bean
	public BoardTypeVOToBoardTypeConverter boardTypeVOToBoardTypeConverter(JpaRepository<BoardType, Long> repository){
		return new BoardTypeVOToBoardTypeConverter(repository);
	}
	
	/**
	 * Member Entity 클래스 객체를 MemberVO 클래스 객체로 변환하는 Converter 클래스 객체를 bean으로 등록한다
	 * @return
	 */
	@Bean
	public MemberToMemberVOConverter memberToMemberVOConverter(){
		return new MemberToMemberVOConverter();
	}
	
	/**
	 * MemberVO 클래스 객체를 Member 엔티티 클래스 객체로 변환하는 Converter 클래스 객체를 bean으로 등록한다
	 * @param repository Member 엔티티 관련 Spring Data JpaRepository 인터페이스를 구현한 bean 객체
	 * @return
	 */
	@Bean
	public MemberVOToMemberConverter memberVOToMemberConverter(JpaRepository<Member, Long> repository){
		return new MemberVOToMemberConverter(repository);
	}
}
